part of 'background_service.dart';

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  try {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  } catch (e) {
    debugPrint('Error configuring audio session: $e');
  }

  _disposeListeners();
  _subscriptions = [];

  _isRunning = false;
  _remainingOnPause = 0;
  _isUIForeground = true;

  // Start hidden when app is in foreground.
  if (service is AndroidServiceInstance) {
    service.setAsBackgroundService();
  }

  _subscriptions!.add(
    service.on('startTimer').listen((event) async {
      if (event == null) return;

      final duration = (event['duration'] as int);
      final initialDuration = (event['initialDuration'] as int);

      _workDuration = (event['workDuration'] as int?) ?? initialDuration;
      _breakDuration = (event['breakDuration'] as int?) ?? 0;
      _round = (event['round'] as int?) ?? 1;
      _totalRounds = (event['totalRounds'] as int?) ?? 1;
      final incomingMode = (event['mode'] as String?) ?? 'work';
      _mode = incomingMode == 'break' ? 'break' : 'work';
      _alarmWorkPath = (event['alarmWorkPath'] as String?) ?? '';
      _alarmBreakPath = (event['alarmBreakPath'] as String?) ?? '';
      _volumeWorkAlarm =
          (event['volumeWorkAlarm'] as num?)?.toDouble() ?? 100.0;
      _volumeBreakAlarm =
          (event['volumeBreakAlarm'] as num?)?.toDouble() ?? 100.0;
      _initialDuration = initialDuration;
      final nowMs = DateTime.now().millisecondsSinceEpoch;
      _endAtMs = nowMs + duration * 1000;
      _isRunning = true;

      _timer?.cancel();
      _startTick(service);
      _broadcastUpdate(service);
      _refreshNotificationIfNeeded();
    }),
  );

  _subscriptions!.add(
    service.on('pauseTimer').listen((event) async {
      if (!_isRunning) return;

      final remaining = _remainingSeconds;

      _remainingOnPause = remaining;
      _isRunning = false;

      _timer?.cancel();
      _broadcastUpdate(service);
      _refreshNotificationIfNeeded();
    }),
  );

  _subscriptions!.add(
    service.on('resumeTimer').listen((event) async {
      if (_isRunning) return;

      final remaining = _remainingSeconds;
      final nowMs = DateTime.now().millisecondsSinceEpoch;

      _endAtMs = nowMs + remaining * 1000;
      _isRunning = true;
      _remainingOnPause = 0;

      _timer?.cancel();
      _startTick(service);
      _broadcastUpdate(service);
      _refreshNotificationIfNeeded();
    }),
  );

  _subscriptions!.add(
    service.on('getState').listen((event) {
      _broadcastUpdate(service);
    }),
  );

  _subscriptions!.add(
    service.on('stopService').listen((event) async {
      _timer?.cancel();
      _disposeListeners();
      service.stopSelf();
    }),
  );

  _subscriptions!.add(
    service.on('ui_detached').listen((event) async {
      if (!_isRunning) {
        _timer?.cancel();
        _disposeListeners();
        service.stopSelf();
      }
    }),
  );

  _subscriptions!.add(
    service.on('ui_state').listen((event) async {
      if (event != null && event['is_foreground'] != null) {
        _isUIForeground = event['is_foreground'] as bool;
        if (service is AndroidServiceInstance) {
          if (_isUIForeground) {
            service.setAsBackgroundService();
          } else {
            service.setAsForegroundService();
            _refreshNotificationIfNeeded();
          }
        }
      }
    }),
  );
}

void _disposeListeners() {
  if (_subscriptions != null) {
    for (var sub in _subscriptions!) {
      sub.cancel();
    }
    _subscriptions = null;
  }
}

// Drives timer progression and pushes state updates every second.
void _startTick(ServiceInstance service) {
  _timer?.cancel();
  _timer = Timer.periodic(const Duration(seconds: 1), (t) async {
    try {
      if (!_isRunning) {
        t.cancel();
        return;
      }

      final remaining = _remainingSeconds;

      final minutes = (remaining ~/ 60).toString().padLeft(2, '0');
      final seconds = (remaining % 60).toString().padLeft(2, '0');

      service.invoke('update', {
        "current_duration": remaining,
        "initial_duration": _initialDuration,
        "is_running": true,
        "round": _round,
        "total_rounds": _totalRounds,
        "mode": _mode,
        "timeMode": _currentTimeMode,
      });

      if (!_isUIForeground) {
        // We revert to manual 1-second update so the countdown shows prominently in the Title.
        // Note: Android OS may sometimes throttle these rapid string updates natively, causing minor visible stutter.
        _updateNotification(
          "$_currentLabel - $minutes:$seconds",
          remaining,
          _initialDuration,
        );
      }

      // Complete after pushing 00:00 to the UI.
      if (remaining <= 0) {
        await _handleSessionFinished(service);
        return;
      }
    } catch (e) {
      debugPrint('Error in timer tick: $e');
    }
  });
}

Future<void> _handleSessionFinished(ServiceInstance service) async {
  try {
    final isWork = _mode == 'work';

    // Stop current loop before transitioning state.
    _isRunning = false;
    _timer?.cancel();

    if (isWork) {
      service.invoke('work_session_done', {
        'work_duration_seconds': _workDuration,
      });

      if (_round < _totalRounds) {
        await _playAlarmAndWait(_alarmWorkPath, _volumeWorkAlarm);
        final nextDuration = _breakDuration;
        final nowMs = DateTime.now().millisecondsSinceEpoch;

        _endAtMs = nowMs + nextDuration * 1000;
        _initialDuration = nextDuration;
        _mode = 'break';
        _isRunning = true;

        _broadcastUpdate(service);
        _startTick(service);
        _refreshNotificationIfNeeded();
      } else {
        await _updateNotification("Finish!", 0, _initialDuration);
        service.invoke('finished');

        await _playAlarmAndWait(_alarmWorkPath, _volumeWorkAlarm);
        await _disposeAudio();
        _disposeListeners();
        service.stopSelf();
        return;
      }
    } else {
      log('Break xong -> sang Work, tăng round');
      await _playAlarmAndWait(_alarmBreakPath, _volumeBreakAlarm);
      final nextRound = _round + 1;
      final nextDuration = _workDuration;
      final nowMs = DateTime.now().millisecondsSinceEpoch;

      _endAtMs = nowMs + nextDuration * 1000;
      _initialDuration = nextDuration;
      _round = nextRound;
      _mode = 'work';
      _isRunning = true;

      _broadcastUpdate(service);
      _startTick(service);
      _refreshNotificationIfNeeded();
    }
  } catch (e) {
    debugPrint('Error handling session finished: $e');
  }
}

void _broadcastUpdate(ServiceInstance service) {
  service.invoke('update', {
    "current_duration": _remainingSeconds,
    "initial_duration": _initialDuration,
    "is_running": _isRunning,
    "round": _round,
    "total_rounds": _totalRounds,
    "mode": _mode,
    "timeMode": _currentTimeMode,
  });
}
