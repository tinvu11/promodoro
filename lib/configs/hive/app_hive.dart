import 'package:hive_ce_flutter/adapters.dart';
import 'package:pomodoro/data/models/daily_stat.dart';
import 'package:pomodoro/data/models/theme_model.dart';
import 'package:pomodoro/hive_registrar.g.dart';

import '../../data/models/settings_model.dart';

class AppHive {
  static const String settingsModelKey = 'settingsModel';
  static const String dailyStatisKey = 'dailyStatisSnapshot';
  static const String themesKey = 'themesCache';

  Box<SettingsModel> get settingsBox =>
      Hive.box<SettingsModel>(settingsModelKey);

  Box<DailyStat> get dailyStatBox => Hive.box<DailyStat>(dailyStatisKey);

  Box<ThemeModel> get themesBox => Hive.box<ThemeModel>(themesKey);

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapters();
    await Hive.openBox<SettingsModel>(settingsModelKey);
    await Hive.openBox<DailyStat>(dailyStatisKey);
    await Hive.openBox<ThemeModel>(themesKey);
  }
}
