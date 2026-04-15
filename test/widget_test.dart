import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro/data/models/alarm_model.dart';
import 'package:pomodoro/data/models/settings_model.dart';

void main() {
  test('SettingsModel.copyWith keeps existing fields', () {
    final settings = SettingsModel(
      workTime: 25,
      breakTime: 5,
      repeatCount: 4,
      isSoundEnabled: true,
      selectedThemeId: 'theme_1',
      alarmWork: const AlarmModel(
        id: 'alarm_work',
        name: {'en': 'Bell'},
        path: 'assets/alarm/bell.mp3',
      ),
      alarmBreak: const AlarmModel(
        id: 'alarm_break',
        name: {'en': 'Bird'},
        path: 'assets/alarm/bird.mp3',
      ),
      volumeWorkAlarm: 80,
      volumeBreakAlarm: 60,
      volumeNoise: 50,
      alwaysOnScreen: true,
      themeName: 'Ocean Waves',
    );

    final updated = settings.copyWith(workTime: 30);

    expect(updated.workTime, 30);
    expect(updated.breakTime, 5);
    expect(updated.repeatCount, 4);
    expect(updated.themeName, 'Ocean Waves');
  });

  test('SettingsModel.copyWith updates theme name when provided', () {
    final settings = SettingsModel(
      workTime: 25,
      breakTime: 5,
      repeatCount: 4,
      isSoundEnabled: true,
      selectedThemeId: 'theme_1',
      alarmWork: const AlarmModel(
        id: 'alarm_work',
        name: {'en': 'Bell'},
        path: 'assets/alarm/bell.mp3',
      ),
      alarmBreak: const AlarmModel(
        id: 'alarm_break',
        name: {'en': 'Bird'},
        path: 'assets/alarm/bird.mp3',
      ),
      volumeWorkAlarm: 80,
      volumeBreakAlarm: 60,
      volumeNoise: 50,
      alwaysOnScreen: true,
      themeName: 'Ocean Waves',
    );

    final updated = settings.copyWith(themeNane: 'Forest');

    expect(updated.themeName, 'Forest');
  });
}
