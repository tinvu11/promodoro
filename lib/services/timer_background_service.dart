import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pomodoro/configs/di.dart';
import 'timer_controller.dart';

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (!DI.sl.isRegistered<PomodoroTimerController>()) {
    await DI.init();
  }

  final controller = DI.sl<PomodoroTimerController>(param1: service);

  // Đăng ký Listeners
  service
      .on('setSettings')
      .listen((event) => controller.updateSettings(event!));
  service.on('start').listen((_) => controller.start());
  service.on('pause').listen((_) => controller.pause());
  service.on('next').listen((_) => controller.next());
  service.on('reset').listen((_) {
    controller.reset();
    service.stopSelf();
  });
  service.on('requestState').listen((_) => controller.broadcast());
}

class PomodoroBackgroundService {
  static final PomodoroBackgroundService _instance =
      PomodoroBackgroundService._internal();
  factory PomodoroBackgroundService() => _instance;
  PomodoroBackgroundService._internal();

  final service = FlutterBackgroundService();

  Future<void> initialize() async {
    print('Initializing Pomodoro Background Service');

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'pomodoro_timer_channel', // id
      'Pomodoro Timer', // name
      description: 'Ongoing Pomodoro Timer Notification',
      importance: Importance.low,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

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

  Future<void> start() async {
    final isRunning = await service.isRunning();
    if (!isRunning) {
      print('Starting Pomodoro Background Service');
      await service.startService();
      await Future.delayed(const Duration(milliseconds: 300));
    } else {
      print('Service is already running');
    }
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

  Future<void> setSettings(Map<String, dynamic> settings) async {
    final isRunning = await service.isRunning();
    // if (!isRunning) {
    //   await service.startService();
    //   await Future.delayed(const Duration(milliseconds: 300));
    // }
    service.invoke('setSettings', settings);
  }
}
