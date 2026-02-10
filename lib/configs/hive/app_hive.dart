import 'package:hive_ce_flutter/adapters.dart';
import 'package:promodoro/data/models/daily_stat.dart';
import 'package:promodoro/hive_registrar.g.dart';

import '../../data/models/settings_model.dart';

class AppHive {
  static const String settingsModelKey = 'settingsModel';
  static const String dailyStatisKey = 'dailyStatisSnapshot';

  Box<SettingsModel> get settingsBox =>
      Hive.box<SettingsModel>(settingsModelKey);

  Box<DailyStat> get dailyStatBox => Hive.box<DailyStat>(dailyStatisKey);

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapters();
    await Hive.openBox<SettingsModel>(settingsModelKey);
    await Hive.openBox<DailyStat>(dailyStatisKey);
  }
}
