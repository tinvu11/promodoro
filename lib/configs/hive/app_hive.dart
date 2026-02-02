import 'package:hive_ce_flutter/adapters.dart';
import 'package:promodoro/hive_registrar.g.dart';
import '../../data/models/settings_model.dart';

class AppHive {
  static const String settingsModelKey = 'settingsModel';
  Box<SettingsModel> get settingsBox => Hive.box<SettingsModel>(settingsModelKey);

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapters();
    await Hive.openBox<SettingsModel>(settingsModelKey);
  }
}
