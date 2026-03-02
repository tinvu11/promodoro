import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:promodoro/data/repositories/stat_repository.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final StatRepository _statRepository;
  Timer? _localTimer;
  int _lastSyncMs = 0;
  final List<StreamSubscription> _subscriptions = [];

  TimerBloc({required StatRepository statRepository})
    : _statRepository = statRepository,
      super(
        const TimerInitial(
          duration: _defaultDuration,
          round: 1,
          totalRounds: 1,
        ),
      ) {
    on<TimerStarted>(_onStarted);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
    on<_LocalTick>(_onLocalTick);
    on<TimerSynced>(_onSynced);
    on<TimerFinished>(_onFinished);
    on<_WorkSessionDone>(_onWorkSessionDone);

    _subscriptions.add(
      FlutterBackgroundService().on('work_session_done').listen((event) {
        if (event != null) {
          add(
            _WorkSessionDone(
              workDurationSeconds:
                  (event['work_duration_seconds'] as int?) ?? 0,
            ),
          );
        }
      }),
    );

    _subscriptions.add(
      FlutterBackgroundService().on('finished').listen((event) {
        add(const TimerFinished());
      }),
    );

    _subscriptions.add(
      FlutterBackgroundService().on('update').listen((event) {
        if (event != null) {
          add(
            TimerSynced(
              duration: event['current_duration'] as int,
              initialDuration: event['initial_duration'] as int,
              round: event['round'] as int,
              totalRounds: event['total_rounds'] as int,
              isRunning: event['is_running'] as bool,
              mode: (event['mode'] == 'work')
                  ? TimerMode.work
                  : TimerMode.breakMode,
            ),
          );
        }
      }),
    );
    _requestSync();
  }

  void _requestSync() async {
    final service = FlutterBackgroundService();
    if (await service.isRunning()) {
      service.invoke('getState');
    }
  }

  void _onSynced(TimerSynced event, Emitter<TimerState> emit) {
    _lastSyncMs = DateTime.now().millisecondsSinceEpoch;

    if (event.isRunning) {
      emit(
        TimerRunInProgress(
          duration: event.duration,
          initialDuration: event.initialDuration,
          round: event.round,
          totalRounds: event.totalRounds,
          mode: event.mode,
        ),
      );
      if (_localTimer == null) _startLocalTimer();
    } else if (event.duration < event.initialDuration &&
        event.initialDuration > 0) {
      _stopLocalTimer();
      emit(
        TimerRunPause(
          duration: event.duration,
          initialDuration: event.initialDuration,
          round: event.round,
          totalRounds: event.totalRounds,
          mode: event.mode,
        ),
      );
    } else {
      _stopLocalTimer();
      // nếu không chạy và chưa từng start, để Initial
      emit(
        TimerInitial(
          duration: _workDuration > 0 ? _workDuration : _defaultDuration,
          round: 1,
          totalRounds: _totalRounds,
        ),
      );
    }
  }

  static const int _defaultDuration = 60;

  int _workDuration = 0;
  int _breakDuration = 0;
  int _totalRounds = 1;

  Future<void> _onStarted(TimerStarted event, Emitter<TimerState> emit) async {
    _workDuration = event.workDuration;
    _breakDuration = event.breakDuration;
    _totalRounds = event.totalRounds;

    emit(
      TimerRunInProgress(
        duration: event.workDuration,
        mode: TimerMode.work,
        round: 1,
        totalRounds: _totalRounds,
        initialDuration: event.workDuration,
      ),
    );

    final service = FlutterBackgroundService();
    if (!await service.isRunning()) {
      await service.startService();
      await Future.delayed(const Duration(milliseconds: 300));
    }

    // ✅ GỬI FULL CONFIG
    service.invoke('startTimer', {
      'duration': event.workDuration,
      'initialDuration': event.workDuration,
      'workDuration': _workDuration,
      'breakDuration': _breakDuration,
      'round': 1,
      'totalRounds': _totalRounds,
      'mode': 'work',
      'alarmWorkPath': event.alarmWorkPath,
      'alarmBreakPath': event.alarmBreakPath,
      'volumeWorkAlarm': event.volumeWorkAlarm,
      'volumeBreakAlarm': event.volumeBreakAlarm,
    });

    _lastSyncMs = DateTime.now().millisecondsSinceEpoch;
    _startLocalTimer();
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress) {
      _stopLocalTimer();
      FlutterBackgroundService().invoke('pauseTimer');
      emit(
        TimerRunPause(
          duration: state.duration,
          mode: state.mode,
          round: state.round,
          totalRounds: state.totalRounds,
          initialDuration: state.initialDuration,
        ),
      );
    }
  }

  void _onResumed(TimerResumed event, Emitter<TimerState> emit) {
    if (state is TimerRunPause) {
      // ✅ RESUME bằng event riêng
      FlutterBackgroundService().invoke('resumeTimer');
      emit(
        TimerRunInProgress(
          duration: state.duration,
          mode: state.mode,
          round: state.round,
          totalRounds: state.totalRounds,
          initialDuration: state.initialDuration,
        ),
      );
      _lastSyncMs = DateTime.now().millisecondsSinceEpoch;
      _startLocalTimer();
    }
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _stopLocalTimer();
    FlutterBackgroundService().invoke('stopService');
    emit(
      TimerInitial(
        duration: _workDuration > 0 ? _workDuration : _defaultDuration,
        round: 1,
        totalRounds: _totalRounds,
      ),
    );
  }

  void _onFinished(TimerFinished event, Emitter<TimerState> emit) {
    _stopLocalTimer();
    emit(
      TimerRunComplete(
        round: _totalRounds,
        totalRounds: _totalRounds,
        initialDuration: _workDuration,
      ),
    );
  }

  Future<void> _onWorkSessionDone(
    _WorkSessionDone event,
    Emitter<TimerState> emit,
  ) async {
    final minutes = (event.workDurationSeconds / 60).round();
    if (minutes <= 0) return;

    final now = DateTime.now();
    final today = _statRepository.getDailyStatByDate(now);
    final updated = today.copyWith(
      minutes: today.minutes + minutes,
      sessions: today.sessions + 1,
    );
    await _statRepository.saveDailyStat(updated);
  }

  /// Local tick chỉ kích hoạt khi service chưa sync trong >1.2s (backup khi IPC bị delay)
  void _onLocalTick(_LocalTick event, Emitter<TimerState> emit) {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastSyncMs < 1200) return;

    if (state is TimerRunInProgress) {
      final newDuration = state.duration - 1;
      if (newDuration >= 0) {
        emit(
          TimerRunInProgress(
            duration: newDuration,
            mode: state.mode,
            round: state.round,
            totalRounds: state.totalRounds,
            initialDuration: state.initialDuration,
          ),
        );
      }
    }
  }

  void _startLocalTimer() {
    _localTimer?.cancel();
    _localTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(const _LocalTick());
    });
  }

  void _stopLocalTimer() {
    _localTimer?.cancel();
    _localTimer = null;
  }

  @override
  Future<void> close() {
    _stopLocalTimer();
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    return super.close();
  }
}
