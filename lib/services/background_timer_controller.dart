import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'background_audio_manager.dart';
import 'background_notification_manager.dart';
import 'background_timer_state.dart';

class BackgroundTimerController {
  final ServiceInstance service;
  final BackgroundTimerState state;
  final BackgroundAudioManager audioManager;
  final BackgroundNotificationManager notifyManager;

  Timer? _timer;
  final List<StreamSubscription> _subscriptions = [];

  BackgroundTimerController({
    required this.service,
    required this.state,
    required this.audioManager,
    required this.notifyManager,
  });

  void init() {
    state.isRunning = false;
    state.remainingOnPause = 0;
    state.isUIForeground = true;

    // Start hidden when app is in foreground.
    if (service is AndroidServiceInstance) {
      (service as AndroidServiceInstance).setAsBackgroundService();
    }

    _subscriptions.add(
      service.on('startTimer').listen((event) async {
        if (event == null) return;

        final duration = (event['duration'] as int);
        final initialDuration = (event['initialDuration'] as int);

        state.workDuration = (event['workDuration'] as int?) ?? initialDuration;
        state.breakDuration = (event['breakDuration'] as int?) ?? 0;
        state.round = (event['round'] as int?) ?? 1;
        state.totalRounds = (event['totalRounds'] as int?) ?? 1;
        final incomingMode = (event['mode'] as String?) ?? 'work';
        state.mode = incomingMode == 'break' ? 'break' : 'work';
        state.alarmWorkPath = (event['alarmWorkPath'] as String?) ?? '';
        state.alarmBreakPath = (event['alarmBreakPath'] as String?) ?? '';
        state.volumeWorkAlarm =
            (event['volumeWorkAlarm'] as num?)?.toDouble() ?? 100.0;
        state.volumeBreakAlarm =
            (event['volumeBreakAlarm'] as num?)?.toDouble() ?? 100.0;
        state.initialDuration = initialDuration;

        final nowMs = DateTime.now().millisecondsSinceEpoch;
        state.endAtMs = nowMs + duration * 1000;
        state.isRunning = true;

        _timer?.cancel();
        _startTick();
        _broadcastUpdate();
        notifyManager.refreshIfNeeded(state);
      }),
    );

    _subscriptions.add(
      service.on('pauseTimer').listen((event) async {
        if (!state.isRunning) return;

        final remaining = state.remainingSeconds;
        state.remainingOnPause = remaining;
        state.isRunning = false;

        _timer?.cancel();
        _broadcastUpdate();
        notifyManager.refreshIfNeeded(state);
      }),
    );

    _subscriptions.add(
      service.on('resumeTimer').listen((event) async {
        if (state.isRunning) return;

        final remaining =
            state.remainingSeconds; // Actually gets paused remaining
        final nowMs = DateTime.now().millisecondsSinceEpoch;

        state.endAtMs = nowMs + remaining * 1000;
        state.isRunning = true;
        state.remainingOnPause = 0;

        _timer?.cancel();
        _startTick();
        _broadcastUpdate();
        notifyManager.refreshIfNeeded(state);
      }),
    );

    _subscriptions.add(
      service.on('getState').listen((event) {
        _broadcastUpdate();
      }),
    );

    _subscriptions.add(
      service.on('stopService').listen((event) async {
        _timer?.cancel();
        _disposeListeners();
        service.stopSelf();
      }),
    );

    _subscriptions.add(
      service.on('ui_detached').listen((event) async {
        if (!state.isRunning) {
          _timer?.cancel();
          _disposeListeners();
          service.stopSelf();
        }
      }),
    );

    _subscriptions.add(
      service.on('ui_state').listen((event) async {
        if (event != null && event['is_foreground'] != null) {
          state.isUIForeground = event['is_foreground'] as bool;
          if (service is AndroidServiceInstance) {
            if (state.isUIForeground) {
              (service as AndroidServiceInstance).setAsBackgroundService();
            } else {
              (service as AndroidServiceInstance).setAsForegroundService();
              notifyManager.refreshIfNeeded(state);
            }
          }
        }
      }),
    );
  }

  void _disposeListeners() {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    audioManager.dispose();
  }

  void _startTick() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      try {
        if (!state.isRunning) {
          t.cancel();
          return;
        }

        final remaining = state.remainingSeconds;

        service.invoke('update', {
          "current_duration": remaining,
          "initial_duration": state.initialDuration,
          "is_running": true,
          "round": state.round,
          "total_rounds": state.totalRounds,
          "mode": state.mode,
          "timeMode": state.currentTimeMode,
        });

        if (!state.isUIForeground) {
          final minutes = (remaining ~/ 60).toString().padLeft(2, '0');
          final seconds = (remaining % 60).toString().padLeft(2, '0');
          notifyManager.updateNotification("$minutes:$seconds");
        }

        if (remaining <= 0) {
          await _handleSessionFinished();
          return;
        }
      } catch (e) {
        debugPrint('Error in timer tick: $e');
      }
    });
  }

  Future<void> _handleSessionFinished() async {
    try {
      final isWork = state.mode == 'work';

      state.isRunning = false;
      _timer?.cancel();

      if (isWork) {
        service.invoke('work_session_done', {
          'work_duration_seconds': state.workDuration,
        });

        if (state.round < state.totalRounds) {
          await audioManager.playAlarmAndWait(
            state.alarmWorkPath,
            state.volumeWorkAlarm,
          );
          final nextDuration = state.breakDuration;
          final nowMs = DateTime.now().millisecondsSinceEpoch;

          state.endAtMs = nowMs + nextDuration * 1000;
          state.initialDuration = nextDuration;
          state.mode = 'break';
          state.isRunning = true;

          _broadcastUpdate();
          _startTick();
          notifyManager.refreshIfNeeded(state);
        } else {
          await notifyManager.updateNotification("Finish!");
          service.invoke('finished');

          await audioManager.playAlarmAndWait(
            state.alarmWorkPath,
            state.volumeWorkAlarm,
          );

          _disposeListeners();
          service.stopSelf();
          return;
        }
      } else {
        log('Break xong -> sang Work, tăng round');
        await audioManager.playAlarmAndWait(
          state.alarmBreakPath,
          state.volumeBreakAlarm,
        );
        final nextRound = state.round + 1;
        final nextDuration = state.workDuration;
        final nowMs = DateTime.now().millisecondsSinceEpoch;

        state.endAtMs = nowMs + nextDuration * 1000;
        state.initialDuration = nextDuration;
        state.round = nextRound;
        state.mode = 'work';
        state.isRunning = true;

        _broadcastUpdate();
        _startTick();
        notifyManager.refreshIfNeeded(state);
      }
    } catch (e) {
      debugPrint('Error handling session finished: $e');
    }
  }

  void _broadcastUpdate() {
    service.invoke('update', {
      "current_duration": state.remainingSeconds,
      "initial_duration": state.initialDuration,
      "is_running": state.isRunning,
      "round": state.round,
      "total_rounds": state.totalRounds,
      "mode": state.mode,
      "timeMode": state.currentTimeMode,
    });
  }
}
