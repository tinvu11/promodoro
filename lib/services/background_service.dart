import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audio_session/audio_session.dart';

import 'background_audio_manager.dart';
import 'background_notification_manager.dart';
import 'background_timer_controller.dart';
import 'background_timer_state.dart';

const _notificationId = 888;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'timer_channel',
    'Timer Service',
    description: 'App is running in the background',
    importance: Importance.low,
  );

  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  
  await notificationsPlugin
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
      initialNotificationTitle: 'Ready timer',
      initialNotificationContent: '',
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

  try {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  } catch (e) {
    debugPrint('Error configuring audio session: $e');
  }

  final state = BackgroundTimerState();
  final audioManager = BackgroundAudioManager();
  final notifyManager = BackgroundNotificationManager(
    plugin: FlutterLocalNotificationsPlugin(),
    notificationId: _notificationId,
  );

  BackgroundTimerController(
    service: service,
    state: state,
    audioManager: audioManager,
    notifyManager: notifyManager,
  ).init();
}
