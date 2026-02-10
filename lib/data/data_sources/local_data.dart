import 'package:intl/intl.dart';
import 'package:promodoro/data/models/alarm_model.dart';
import 'package:promodoro/data/models/daily_stat.dart';
import 'package:promodoro/data/models/settings_model.dart';

import '../../configs/hive/app_hive.dart';

abstract interface class LocalData {
  Future<void> saveSettings(SettingsModel settingsModel);

  Future<void> saveDailyStat(DailyStat dailyStat);

  SettingsModel getSettings();

  List<DailyStat> getDailyStat();

  List<DailyStat> getDailyStatByMonth(int year, int month);

  DailyStat getDailyStatByDate(DateTime date);

  int getTotalMinutes();

  int getTotalSessions();
}

class HiveDatabase implements LocalData {
  static const String _settingsModelKey = 'settingsSnapshot';
  final AppHive _appHive;

  HiveDatabase({required AppHive appHive}) : _appHive = appHive;

  @override
  SettingsModel getSettings() {
    return _appHive.settingsBox.get(_settingsModelKey) ??
        SettingsModel(
          workTime: 2500,
          breakTime: 300,
          repeatCount: 5,
          isSoundEnabled: true,
          selectedThemeId: "1path theme",
          alarmWork: AlarmModel(
            id: "1",
            name: "Happy",
            path: "assets/alarm/alarm1.mp3",
          ),
          alarmBreak: AlarmModel(
            id: "2",
            name: "Gentle",
            path: "assets/alarm/alarm2.mp3",
          ),
          volumeWorkAlarm: 60,
          volumeBreakAlarm: 20,
          volumeNoise: 90,
          alwaysOnScreen: true,
        );
  }

  @override
  List<DailyStat> getDailyStat() {
    return _appHive.dailyStatBox.values.toList();
  }

  @override
  List<DailyStat> getDailyStatByMonth(int year, int month) {
    return _appHive.dailyStatBox.values
        .where((s) => s.date.year == year && s.date.month == month)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  @override
  DailyStat getDailyStatByDate(DateTime date) {
    final id = DateFormat('yyyy-MM-dd').format(date);
    return _appHive.dailyStatBox.get(id) ?? DailyStat(date: date);
  }

  @override
  int getTotalMinutes() {
    return _appHive.dailyStatBox.values.fold(0, (sum, s) => sum + s.minutes);
  }

  @override
  int getTotalSessions() {
    return _appHive.dailyStatBox.values.fold(0, (sum, s) => sum + s.sessions);
  }

  @override
  Future<void> saveSettings(SettingsModel settingsModel) async {
    await _appHive.settingsBox.put(_settingsModelKey, settingsModel);
  }

  @override
  Future<void> saveDailyStat(DailyStat dailyStat) async {
    await _appHive.dailyStatBox.put(dailyStat.id, dailyStat);
  }
}
