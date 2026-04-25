import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pomodoro/data/repositories/stat_repository.dart';

enum PomodoroSession { work, shortBreak, longBreak }

enum TimerStatus { initial, running, paused, finished }

class PomodoroTimerController {
  final ServiceInstance service;
  final FlutterLocalNotificationsPlugin notifications;
  final StatRepository statRepository;

  PomodoroTimerController({
    required this.service,
    required this.notifications,
    required this.statRepository,
  });

  // Trạng thái Timer
  int workTime = 25 * 60;
  int breakTime = 5 * 60;
  int repeatCount = 4;

  PomodoroSession currentSession = PomodoroSession.work;
  TimerStatus currentStatus = TimerStatus.initial;
  int currentCycle = 1;
  int totalDuration = 25 * 60;

  int _previouslyElapsedSeconds = 0;
  DateTime? _resumeTime;
  Timer? _timer;

  // PomodoroTimerController(this.service, this.notifications);

  void updateSettings(Map<String, dynamic> settings) {
    workTime = settings['workTime'] ?? workTime;
    breakTime = settings['breakTime'] ?? breakTime;
    repeatCount = settings['repeatCount'] ?? repeatCount;

    if (currentStatus == TimerStatus.initial) {
      totalDuration = currentSession == PomodoroSession.work
          ? workTime
          : breakTime;
      broadcast();
    }
  }

  void start() {
    if (currentStatus == TimerStatus.running) {
      return;
    }
    _resumeTime = DateTime.now();
    currentStatus = TimerStatus.running;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) => _tick());
    broadcast();
    _updateNotification();
  }

  void pause() {
    if (currentStatus != TimerStatus.running) return;
    _previouslyElapsedSeconds += _calculateElapsedSinceResume();
    currentStatus = TimerStatus.paused;
    _timer?.cancel();
    broadcast();
    _updateNotification();
  }

  void next() {
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
    notifications.cancel(id: 888);
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
    broadcast();
  }

  // save stats when session works finishes
  void saveStats(int workDurationSeconds) {
    print('Saving stats: $workDurationSeconds seconds');
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
      if (currentCycle >= repeatCount) {
        reset();
      } else {
        saveStats(currentSession == PomodoroSession.work ? totalDuration : 0);
        next();
      }
    } else {
      _updateNotification(remaining);
      service.invoke('update', {
        'status': currentStatus.index,
        'session': currentSession.index,
        'remainingSeconds': remaining,
        'cycle': currentCycle,
      });
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
          ? 'Working ($currentCycle/$repeatCount)'
          : 'Break Time',
      body: '$mins:$secs remaining',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'pomodoro_timer_channel',
          'Pomodoro Timer',
          importance: Importance.low,
          priority: Priority.low,
          ongoing: true,
          onlyAlertOnce: true,
          icon: "@mipmap/ic_launcher",
        ),
      ),
    );
  }
}
