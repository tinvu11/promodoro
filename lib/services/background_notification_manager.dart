import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'background_timer_state.dart';

class BackgroundNotificationManager {
  final FlutterLocalNotificationsPlugin plugin;
  final int notificationId;

  BackgroundNotificationManager({
    required this.plugin,
    this.notificationId = 888,
  });

  void refreshIfNeeded(BackgroundTimerState state) {
    if (!state.isUIForeground) {
      if (state.isRunning) {
        final remaining = state.remainingSeconds;
        final minutes = (remaining ~/ 60).toString().padLeft(2, '0');
        final seconds = (remaining % 60).toString().padLeft(2, '0');
        updateNotification("$minutes:$seconds");
      } else {
        final remaining = state.remainingOnPause;
        final minutes = (remaining ~/ 60).toString().padLeft(2, '0');
        final seconds = (remaining % 60).toString().padLeft(2, '0');
        updateNotification("$minutes:$seconds");
      }
    }
  }

  Future<void> updateNotification(String content) async {
    try {
      const details = AndroidNotificationDetails(
        'timer_channel',
        'Timer Service',
        icon: '@mipmap/launcher_icon',
        ongoing: true,
        onlyAlertOnce: true,
        importance: Importance.low,
        priority: Priority.low,
        visibility: NotificationVisibility.public,
        styleInformation: DefaultStyleInformation(true, true),
      );

      await plugin.show(
        id: notificationId,
        title: content,
        body: '',
        notificationDetails: const NotificationDetails(android: details),
      );
    } catch (e) {
      debugPrint('Error updating notification: $e');
    }
  }
}
