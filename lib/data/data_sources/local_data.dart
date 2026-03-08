import 'package:intl/intl.dart';
import 'package:promodoro/data/models/alarm_model.dart';
import 'package:promodoro/data/models/daily_stat.dart';
import 'package:promodoro/data/models/settings_model.dart';
import 'package:promodoro/data/models/theme_model.dart';
import 'package:promodoro/services/theme_storage_service.dart';

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

  /// Theme cache methods
  List<ThemeModel> getCachedThemes();

  Future<void> cacheThemes(List<ThemeModel> themes);
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
          selectedThemeId: ThemeStorageService.defaultThemeId,
          alarmWork: AlarmModel(
            id: "1",
            name: {
              "vi": "Vui vẻ",
              "en": "Happy",
              "es": "Feliz",
              "fr": "Heureux",
              "ja": "幸せ",
              "ko": "행복",
              "de": "Glücklich",
              "it": "Felice",
              "ru": "Счастливый",
              "pt": "Feliz",
              "zh": "快乐",
              "hi": "खुश",
              "ar": "سعيد",
              "id": "Senang",
              "tr": "Mutlu",
              "sv": "Lycklig",
              "nl": "Gelukkig",
            },
            path: "assets/alarm/alarm1.mp3",
          ),
          alarmBreak: AlarmModel(
            id: "2",
            name: {
              "vi": "Năng lượng",
              "en": "Energetic",
              "es": "Enérgico",
              "fr": "Énergique",
              "ja": "エネルギッシュ",
              "ko": "활기찬",
              "de": "Energetisch",
              "it": "Energico",
              "ru": "Энергичный",
              "pt": "Enérgico",
              "zh": "有活力",
              "hi": "ऊर्जावान",
              "ar": "مفعم بالحيوية",
              "id": "Enerjik",
              "tr": "Enerjik",
              "sv": "Energisk",
              "nl": "Energieke",
            },
            path: "assets/alarm/alarm2.mp3",
          ),
          volumeWorkAlarm: 60,
          volumeBreakAlarm: 20,
          volumeNoise: 90,
          alwaysOnScreen: true,
          themeName: ThemeStorageService.defaultThemeNames['en']!,
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

  @override
  List<ThemeModel> getCachedThemes() {
    return _appHive.themesBox.values.toList();
  }

  @override
  Future<void> cacheThemes(List<ThemeModel> themes) async {
    await _appHive.themesBox.clear();
    for (final theme in themes) {
      await _appHive.themesBox.put(theme.id, theme);
    }
  }
}
