import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pomodoro/data/repositories/stat_repository.dart';
import 'package:pomodoro/services/audio_service.dart';

enum PomodoroSession { work, shortBreak, longBreak }

enum TimerStatus { initial, running, paused, finished }

class PomodoroTimerController {
  final ServiceInstance service;
  final FlutterLocalNotificationsPlugin notifications;
  final StatRepository statRepository;
  final PomodoroAudioService audioService;

  PomodoroTimerController({
    required this.service,
    required this.notifications,
    required this.statRepository,
    required this.audioService,
  });

  // Trạng thái Timer
  int workTime = 25 * 60;
  int breakTime = 5 * 60;
  int repeatCount = 4;
  int _lastBroadcastedRemaining = -1;
  PomodoroSession currentSession = PomodoroSession.work;
  TimerStatus currentStatus = TimerStatus.initial;
  int currentCycle = 1;
  int totalDuration = 25 * 60;

  int _previouslyElapsedSeconds = 0;
  DateTime? _resumeTime;
  Timer? _timer;

  String currentThemeId = 'default';
  String alarmWorkPath = '';
  String alarmBreakPath = '';
  double currentVolume = 90;
  double volumeAlarmWork = 90;
  double volumeAlarmBreak = 90;
  bool isSoundEnabled = true;
  String l10nFocus = 'Focus';
  String l10nBreak = 'Break';

  // PomodoroTimerController(this.service, this.notifications);

  void updateSettings(Map<String, dynamic> settings) {
    workTime = settings['workTime'] ?? workTime;
    breakTime = settings['breakTime'] ?? breakTime;
    repeatCount = settings['repeatCount'] ?? repeatCount;
    currentThemeId = settings['selectedThemeId'] ?? currentThemeId;
    alarmWorkPath = settings['alarmWorkPath'] ?? alarmWorkPath;
    alarmBreakPath = settings['alarmBreakPath'] ?? alarmBreakPath;
    currentVolume = (settings['volumeNoise'] ?? currentVolume).toDouble();
    volumeAlarmWork = (settings['volumeWorkAlarm'] ?? volumeAlarmWork)
        .toDouble();
    volumeAlarmBreak = (settings['volumeBreakAlarm'] ?? volumeAlarmBreak)
        .toDouble();
    isSoundEnabled = settings['isSoundEnabled'] ?? isSoundEnabled;
    l10nFocus = settings['l10nFocus'] ?? l10nFocus;
    l10nBreak = settings['l10nBreak'] ?? l10nBreak;

    if (currentStatus == TimerStatus.initial) {
      totalDuration = currentSession == PomodoroSession.work
          ? workTime
          : breakTime;
      broadcast();
    }
  }

  void start() {
    if (currentStatus == TimerStatus.running) return;
    _resumeTime = DateTime.now();
    currentStatus = TimerStatus.running;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) => _tick());
    broadcast();
    if (isSoundEnabled && currentSession == PomodoroSession.work) {
      audioService.playNoise(themeId: currentThemeId, volume: currentVolume);
    } else {
      audioService.pauseNoise();
    }
    _updateNotification();
  }

  void pause() {
    if (currentStatus != TimerStatus.running) return;
    _previouslyElapsedSeconds += _calculateElapsedSinceResume();
    currentStatus = TimerStatus.paused;
    _timer?.cancel();
    broadcast();
    if (isSoundEnabled) {
      audioService.pauseNoise();
    }
    _updateNotification();
  }

  void autoNext() async {
    _timer?.cancel();

    if (isSoundEnabled) {
      // Tạm dừng nhạc nền để tiếng chuông rõ ràng hơn
      audioService.pauseNoise();

      // Phát chuông báo tương ứng với session vừa kết thúc
      final alarmPath = (currentSession == PomodoroSession.work)
          ? alarmWorkPath
          : alarmBreakPath;
      final alarmVolume = (currentSession == PomodoroSession.work)
          ? volumeAlarmWork
          : volumeAlarmBreak;
      // Sử dụng hàm phát chuông đã gộp
      audioService.playAlarm(alarmPath, alarmVolume);
    }

    _previouslyElapsedSeconds = 0;
    _resumeTime = null;
    currentStatus = TimerStatus.initial;

    // Chuyển đổi Session
    if (currentSession == PomodoroSession.work) {
      currentSession = PomodoroSession.shortBreak;
      totalDuration = breakTime;
    } else {
      currentSession = PomodoroSession.work;
      totalDuration = workTime;
      currentCycle >= repeatCount ? currentCycle = 1 : currentCycle++;
    }

    broadcast();
    // notifications.cancel(id: 888);
    start();
  }

  void next() async {
    _timer?.cancel();
    _previouslyElapsedSeconds = 0;
    _resumeTime = null;
    currentStatus = TimerStatus.initial;

    if (currentSession == PomodoroSession.work) {
      currentSession = PomodoroSession.shortBreak;
      totalDuration = breakTime;
    } else {
      currentSession = PomodoroSession.work;
      totalDuration = workTime;
      currentCycle >= repeatCount ? currentCycle = 1 : currentCycle++;
    }
    broadcast();
    start();
  }

  void reset() {
    _timer?.cancel();
    currentStatus = TimerStatus.initial;
    currentSession = PomodoroSession.work;
    currentCycle = 1;
    _previouslyElapsedSeconds = 0;
    _resumeTime = null;
    totalDuration = workTime;
    audioService.stopNoise();
    notifications.cancel(id: 888);
    service.stopSelf();
    broadcast();
  }

  // save stats when session works finishes
  void saveStats(int workDurationSeconds) {
    final minutes = (workDurationSeconds / 60).round();
    if (minutes <= 0) return;

    final now = DateTime.now();
    final today = statRepository.getDailyStatByDate(now);
    final updated = today.copyWith(
      minutes: today.minutes + minutes,
      sessions: today.sessions + 1,
    );
    statRepository.saveDailyStat(updated);
  }

  void _tick() {
    int remaining =
        totalDuration -
        (_previouslyElapsedSeconds + _calculateElapsedSinceResume());

    if (remaining <= 0) {
      // if (isSoundEnabled) {
      //   audioService.playAlarm(alarmWorkPath, volumeAlarmWork);
      // }
      if (currentCycle >= repeatCount &&
          currentSession == PomodoroSession.work) {
        saveStats(totalDuration);
        reset();
      } else {
        if (currentSession == PomodoroSession.work) {
          saveStats(totalDuration);
        }
        autoNext();
      }
    } else {
      if (remaining != _lastBroadcastedRemaining) {
        _updateNotification(remaining);
        service.invoke('update', {
          'status': currentStatus.index,
          'session': currentSession.index,
          'remainingSeconds': remaining,
          'cycle': currentCycle,
        });
        _lastBroadcastedRemaining = remaining;
      }
    }
  }

  int _calculateElapsedSinceResume() {
    return _resumeTime != null
        ? DateTime.now().difference(_resumeTime!).inSeconds
        : 0;
  }

  void broadcast() {
    int remaining = totalDuration - _previouslyElapsedSeconds;
    if (currentStatus == TimerStatus.running) {
      remaining -= _calculateElapsedSinceResume();
    }
    service.invoke('update', {
      'status': currentStatus.index,
      'session': currentSession.index,
      'remainingSeconds': remaining < 0 ? 0 : remaining,
      'cycle': currentCycle,
    });
  }

  void _updateNotification([int? remaining]) {
    int seconds = remaining ?? (totalDuration - _previouslyElapsedSeconds);
    final mins = (seconds / 60).floor().toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');

    notifications.show(
      id: 888,
      title: currentSession == PomodoroSession.work
          ? '$l10nFocus ($currentCycle/$repeatCount)'
          : l10nBreak,
      body: '$mins:$secs',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'pomodoro_timer_channel',
          'Pomodoro Timer',
          importance: Importance.low,
          priority: Priority.low,
          ongoing: true,
          onlyAlertOnce: true,
          showWhen: false,
          icon: "@mipmap/ic_launcher",
        ),
      ),
    );
  }
}
