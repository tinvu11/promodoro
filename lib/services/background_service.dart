import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Timer? _timer;
List<StreamSubscription>? _subscriptions;

// State flat structure vs Snapshot model
int _endAtMs = 0;
int _initialDuration = 0;
bool _isRunning = false;
int _round = 1;
int _totalRounds = 1;
String _mode = 'work'; // 'work' | 'break'
int _workDuration = 0;
int _breakDuration = 0;
int _remainingOnPause = 0; // Store remaining seconds when paused
bool _isUIForeground = true; // Track UI state
String _alarmWorkPath = '';
String _alarmBreakPath = '';
double _volumeWorkAlarm = 100.0;
double _volumeBreakAlarm = 100.0;
bool _alwayOnScreen = true;
final AudioPlayer _audioPlayer = AudioPlayer();

int get _remainingSeconds {
  if (!_isRunning) return _remainingOnPause;
  if (_endAtMs == 0) return 0;
  final now = DateTime.now().millisecondsSinceEpoch;
  final diff = _endAtMs - now;
  final sec = (diff + 999) ~/ 1000;
  return sec < 0 ? 0 : sec;
}

final FlutterLocalNotificationsPlugin _notificationsPlugin =
    FlutterLocalNotificationsPlugin();

const _notificationId = 888;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'timer_channel',
    'Timer Service',
    description: 'Ứng dụng đang chạy đếm ngược',
    importance: Importance.low,
  );

  await _notificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: 'timer_channel',
      initialNotificationTitle: 'Pomodoro',
      initialNotificationContent: 'Sẵn sàng...',
      foregroundServiceNotificationId: _notificationId,
      foregroundServiceTypes: [AndroidForegroundType.specialUse],
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async => true;

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  // Dispose các listeners cũ nếu có
  _disposeListeners();
  _subscriptions = [];

  // Reset state
  _isRunning = false;
  _remainingOnPause = 0;
  _isUIForeground = true;
  // _broadcastUpdate(service); // DO NOT BROADCAST YET!

  _subscriptions!.add(
    service.on('startTimer').listen((event) async {
      if (event == null) return;

      // Stop any previously playing alarm exactly when starting a new session
      // await _audioPlayer.stop();

      final duration = (event['duration'] as int);
      final initialDuration = (event['initialDuration'] as int);

      _workDuration = (event['workDuration'] as int?) ?? initialDuration;
      _breakDuration = (event['breakDuration'] as int?) ?? 0;
      _round = (event['round'] as int?) ?? 1;
      _totalRounds = (event['totalRounds'] as int?) ?? 1;
      _mode = (event['mode'] as String?) ?? 'work';
      _alarmWorkPath = (event['alarmWorkPath'] as String?) ?? '';
      _alarmBreakPath = (event['alarmBreakPath'] as String?) ?? '';
      _volumeWorkAlarm =
          (event['volumeWorkAlarm'] as num?)?.toDouble() ?? 100.0;
      _volumeBreakAlarm =
          (event['volumeBreakAlarm'] as num?)?.toDouble() ?? 100.0;
      _initialDuration = initialDuration;
      _alwayOnScreen = (event['alwayOnScreen'] as bool?) ?? true;

      final nowMs = DateTime.now().millisecondsSinceEpoch;
      _endAtMs = nowMs + duration * 1000;
      _isRunning = true;

      _timer?.cancel();
      _startTick(service);
      _broadcastUpdate(service);

      // WakelockPlus được xử lý ở UI side (timer_page.dart)
      // vì background isolate không có Activity Window
    }),
  );

  _subscriptions!.add(
    service.on('pauseTimer').listen((event) async {
      if (!_isRunning) return;

      final remaining = _remainingSeconds;

      _remainingOnPause = remaining;
      _isRunning = false;

      _timer?.cancel();
      await _updateNotification("Đã tạm dừng", remaining, _initialDuration);
      _broadcastUpdate(service);
    }),
  );

  _subscriptions!.add(
    service.on('resumeTimer').listen((event) async {
      if (_isRunning) return;

      final remaining = _remainingSeconds; // will return _remainingOnPause
      final nowMs = DateTime.now().millisecondsSinceEpoch;

      _endAtMs = nowMs + remaining * 1000;
      _isRunning = true;
      _remainingOnPause = 0;

      _timer?.cancel();
      _startTick(service);
      _broadcastUpdate(service);
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
    service.on('ui_state').listen((event) async {
      if (event != null && event['is_foreground'] != null) {
        _isUIForeground = event['is_foreground'] as bool;
        if (_isUIForeground) {
          await _notificationsPlugin.cancel(id: _notificationId);
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

// Hàm chạy liên tục mỗi giây
void _startTick(ServiceInstance service) {
  _timer?.cancel();
  _timer = Timer.periodic(const Duration(seconds: 1), (t) async {
    try {
      // Nếu đang pause thì không tick
      if (!_isRunning) {
        t.cancel();
        return;
      }

      final remaining = _remainingSeconds;

      // Update notif & UI
      final minutes = (remaining ~/ 60).toString().padLeft(2, '0');
      final seconds = (remaining % 60).toString().padLeft(2, '0');

      service.invoke('update', {
        "current_duration": remaining,
        "initial_duration": _initialDuration,
        "is_running": true,
        "round": _round,
        "total_rounds": _totalRounds,
        "mode": _mode,
      });

      if (!_isUIForeground) {
        // Không await để không block tick tiếp theo
        _updateNotification("$minutes:$seconds", remaining, _initialDuration);
      }

      // Kiểm tra hoàn thành SAU khi update UI để hiện 00:00
      if (remaining <= 0) {
        await _handleSessionFinished(service);
        return;
      }
    } catch (e) {
      print('Error in timer tick: $e');
    }
  });
}

Future<void> _handleSessionFinished(ServiceInstance service) async {
  try {
    final isWork = _mode == 'work';

    // Tạm bỏ IsRunning để block tick tiếp theo
    _isRunning = false;
    _timer?.cancel();

    if (isWork) {
      // Work xong -> gửi thông báo hoàn thành 1 session về UI
      service.invoke('work_session_done', {
        'work_duration_seconds': _workDuration,
      });

      // Nếu còn round thì sang Break, không thì complete
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
      } else {
        // hoàn thành tất cả
        await _updateNotification("Hoàn thành!", 0, _initialDuration);
        service.invoke('finished');

        // Phát alarm và đợi phát xong trước khi dừng service
        await _playAlarmAndWait(_alarmWorkPath, _volumeWorkAlarm);

        _disposeListeners();
        service.stopSelf();
        return;
      }
    } else {
      // Break xong -> sang Work, tăng round
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
    }
  } catch (e) {
    print('Error handling session finished: $e');
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
  });
}

Future<void> _updateNotification(String content, int current, int max) async {
  try {
    await _notificationsPlugin.show(
      id: _notificationId,
      title: 'Pomodoro Timer',
      body: content,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'timer_channel',
          'Timer Service',
          icon: '@mipmap/ic_launcher',
          ongoing: true,
          onlyAlertOnce: true,
        ),
      ),
    );
  } catch (e) {
    print('Error updating notification: $e');
  }
}

Future<void> _playAlarm(String assetPath, double volumePercent) async {
  if (assetPath.isEmpty) return;

  final cleanPath = assetPath.startsWith('assets/')
      ? assetPath.replaceFirst('assets/', '')
      : assetPath;
  try {
    await _audioPlayer.stop();
    await _audioPlayer.setVolume(volumePercent / 100.0);
    await _audioPlayer.play(AssetSource(cleanPath));
  } catch (e) {
    print("Error playing alarm in background: $e");
  }
}

/// Phát alarm và đợi audio phát xong (hoặc timeout 10s) trước khi return
Future<void> _playAlarmAndWait(String assetPath, double volumePercent) async {
  if (assetPath.isEmpty) return;

  final completer = Completer<void>();
  StreamSubscription? sub;

  // Timeout phòng trường hợp event không bao giờ fire
  final timer = Timer(const Duration(seconds: 10), () {
    if (!completer.isCompleted) completer.complete();
  });

  sub = _audioPlayer.onPlayerComplete.listen((_) {
    if (!completer.isCompleted) completer.complete();
  });

  await _playAlarm(assetPath, volumePercent);
  await completer.future;

  timer.cancel();
  await sub.cancel();
}
