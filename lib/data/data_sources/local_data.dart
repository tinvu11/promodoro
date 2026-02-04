import 'package:promodoro/data/models/settings_model.dart';
import '../../configs/hive/app_hive.dart';

abstract interface class LocalData {
  Future<void> saveSettings(SettingsModel settingsModel);
  SettingsModel getSettings();
}

class HiveDatabase implements LocalData {
  static const String _settingsModelKey = 'settingsSnapshot';
  final AppHive _appHive;
  HiveDatabase({required AppHive appHive}) : _appHive = appHive;

  @override
  SettingsModel getSettings() {
    return _appHive.settingsBox.get(_settingsModelKey) ??
        SettingsModel(
          workTime: 1500,
          breakTime: 300,
          repeatCount: 5,
          isSoundEnabled: true,
          selectedThemeId: "path theme",
          alarmWork: 'path alarmWork',
          alarmBreak: 'path alarmBreak',
          volumeWorkAlarm: 60,
          volumeBreakAlarm: 20,
          volumeNoise: 90,
          alwaysOnScreen: true,
        );
  }

  @override
  Future<void> saveSettings(SettingsModel settingsModel) async {
    await _appHive.settingsBox.put(_settingsModelKey, settingsModel);
  }
}
