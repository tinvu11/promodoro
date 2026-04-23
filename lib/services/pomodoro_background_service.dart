import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum PomodoroSession { work, shortBreak, longBreak }

enum TimerStatus { initial, running, paused, finished }

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  int workTime = 25 * 60;
  int breakTime = 5 * 60;
  int repeatCount = 4;

  bool isSoundEnabled = true;
  String alarmWorkPath = '';
  String alarmBreakPath = '';
  double volumeWorkAlarm = 1.0;
  double volumeBreakAlarm = 1.0;
  double volumeNoise = 1.0;

  PomodoroSession currentSession = PomodoroSession.work;
  TimerStatus currentStatus = TimerStatus.initial;

  int currentCycle = 1;
  int totalDuration = workTime;

  int previouslyElapsedSeconds = 0;
  DateTime? resumeTime;

  Timer? timer;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Load Settings
  service.on('setSettings').listen((event) {
    if (event != null) {
      workTime = event['workTime'] ?? workTime;
      breakTime = event['breakTime'] ?? breakTime;
      repeatCount = event['repeatCount'] ?? repeatCount;
      isSoundEnabled = event['isSoundEnabled'] ?? true;
      alarmWorkPath = event['alarmWorkPath'] ?? '';
      alarmBreakPath = event['alarmBreakPath'] ?? '';
      volumeWorkAlarm = event['volumeWorkAlarm'] ?? 1.0;
      volumeBreakAlarm = event['volumeBreakAlarm'] ?? 1.0;
      volumeNoise = event['volumeNoise'] ?? 1.0;

      if (currentStatus == TimerStatus.initial) {
        totalDuration = currentSession == PomodoroSession.work
            ? workTime
            : breakTime;
        _broadcastState(
          service,
          currentStatus,
          currentSession,
          totalDuration,
          currentCycle,
        );
      }
    }
  });

  void updateNotification(int remainingSeconds) {
    final minutes = (remainingSeconds / 60).floor().toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    final title = currentSession == PomodoroSession.work
        ? 'Working ($currentCycle/$repeatCount)'
        : 'Break Time';

    flutterLocalNotificationsPlugin.show(
      id: 888, // Đã có tên tham số, giữ nguyên
      title: title, // Đã có tên tham số, giữ nguyên
      body: '$minutes:$seconds remaining', // THÊM 'body:' vào đây
      notificationDetails: NotificationDetails(
        // THÊM 'notificationDetails:' vào đây
        android: AndroidNotificationDetails(
          'pomodoro_timer_channel',
          'Pomodoro Timer',
          channelDescription: 'Ongoing Pomodoro Timer',
          ongoing: true,
          importance: Importance.low,
          priority: Priority.low,
          playSound: false,
          enableVibration: false,
          onlyAlertOnce: true, // Nhớ thêm dòng này như mình đã gợi ý ở trên nhé
        ),
      ),
    );
  }

  void endSession() {
    timer?.cancel();
    currentStatus = TimerStatus.finished;

    // Auto next logic or wait for user to press next
    // Depending on requirements. Let's just wait for user to press next or we can provide a default
    // We will broadcast finished state.
    _broadcastState(service, currentStatus, currentSession, 0, currentCycle);

    flutterLocalNotificationsPlugin.show(
      id: 888,
      title: 'Session Finished',
      body:
          'Time to ${currentSession == PomodoroSession.work ? 'take a break' : 'get back to work'}!',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'pomodoro_timer_channel',
          'Pomodoro Timer',
          ongoing: false,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  void calculateAndUpdate() {
    if (currentStatus != TimerStatus.running) return;

    final now = DateTime.now();
    final elapsedSinceResume = resumeTime != null
        ? now.difference(resumeTime!).inSeconds
        : 0;
    final totalElapsed = previouslyElapsedSeconds + elapsedSinceResume;

    int remaining = totalDuration - totalElapsed;

    if (remaining <= 0) {
      remaining = 0;
      endSession();
    } else {
      updateNotification(remaining);
      _broadcastState(
        service,
        currentStatus,
        currentSession,
        remaining,
        currentCycle,
      );
    }
  }

  service.on('start').listen((event) {
    if (currentStatus == TimerStatus.initial ||
        currentStatus == TimerStatus.paused) {
      resumeTime = DateTime.now();
      currentStatus = TimerStatus.running;

      timer?.cancel();
      timer = Timer.periodic(const Duration(milliseconds: 200), (t) {
        calculateAndUpdate();
      });
    }
  });

  service.on('pause').listen((event) {
    if (currentStatus == TimerStatus.running) {
      final now = DateTime.now();
      final elapsedSinceResume = resumeTime != null
          ? now.difference(resumeTime!).inSeconds
          : 0;
      previouslyElapsedSeconds += elapsedSinceResume;
      currentStatus = TimerStatus.paused;
      timer?.cancel();

      int remaining = totalDuration - previouslyElapsedSeconds;
      _broadcastState(
        service,
        currentStatus,
        currentSession,
        remaining,
        currentCycle,
      );
      updateNotification(remaining);
    }
  });

  service.on('reset').listen((event) {
    timer?.cancel();
    currentStatus = TimerStatus.initial;
    previouslyElapsedSeconds = 0;
    resumeTime = null;
    totalDuration = currentSession == PomodoroSession.work
        ? workTime
        : breakTime;

    _broadcastState(
      service,
      currentStatus,
      currentSession,
      totalDuration,
      currentCycle,
    );

    flutterLocalNotificationsPlugin.cancel(id: 888);
  });

  service.on('next').listen((event) {
    timer?.cancel();
    previouslyElapsedSeconds = 0;
    resumeTime = null;
    currentStatus = TimerStatus.initial;

    if (currentSession == PomodoroSession.work) {
      if (currentCycle >= repeatCount) {
        currentSession = PomodoroSession.longBreak;
        totalDuration = breakTime * 2; // For example, long break is double
      } else {
        currentSession = PomodoroSession.shortBreak;
        totalDuration = breakTime;
      }
    } else {
      currentSession = PomodoroSession.work;
      totalDuration = workTime;
      if (currentSession == PomodoroSession.longBreak) {
        currentCycle = 1;
      } else {
        currentCycle++;
      }
    }

    _broadcastState(
      service,
      currentStatus,
      currentSession,
      totalDuration,
      currentCycle,
    );
    flutterLocalNotificationsPlugin.cancel(
      id: 888,
    ); // Clear notification wait for user to start
  });

  service.on('requestState').listen((event) {
    int remaining = totalDuration - previouslyElapsedSeconds;
    if (currentStatus == TimerStatus.running && resumeTime != null) {
      remaining -= DateTime.now().difference(resumeTime!).inSeconds;
    }
    if (remaining < 0) remaining = 0;
    _broadcastState(
      service,
      currentStatus,
      currentSession,
      remaining,
      currentCycle,
    );
  });
}

void _broadcastState(
  ServiceInstance service,
  TimerStatus status,
  PomodoroSession session,
  int remainingSeconds,
  int cycle,
) {
  service.invoke('update', {
    'status': status.index,
    'session': session.index,
    'remainingSeconds': remainingSeconds,
    'cycle': cycle,
  });
}

class PomodoroBackgroundService {
  static final PomodoroBackgroundService _instance =
      PomodoroBackgroundService._internal();
  factory PomodoroBackgroundService() => _instance;
  PomodoroBackgroundService._internal();

  final service = FlutterBackgroundService();

  Future<void> initialize() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'pomodoro_timer_channel', // id
      'Pomodoro Timer', // name
      description: 'Ongoing Pomodoro Timer Notification',
      importance: Importance.low,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // if (Theme.of(WidgetsBinding.instance.platformDispatcher.implicitView!) !=
    //     null) {
    //   // Just to bypass lint if needed, using dart:ui if view is not null
    // }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: 'pomodoro_timer_channel',
        initialNotificationTitle: 'Pomodoro Ready',
        initialNotificationContent: 'Tap to open',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onStart,
        onBackground: (ServiceInstance service) {
          return true;
        },
      ),
    );
  }

  void start() {
    service.invoke('start');
  }

  void pause() {
    service.invoke('pause');
  }

  void resume() {
    service.invoke('start');
  }

  void reset() {
    service.invoke('reset');
  }

  void next() {
    service.invoke('next');
  }

  void requestState() {
    service.invoke('requestState');
  }

  void setSettings(Map<String, dynamic> settings) {
    service.invoke('setSettings', settings);
  }
}
