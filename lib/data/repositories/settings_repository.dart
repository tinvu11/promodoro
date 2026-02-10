import '../data_sources/local_data.dart';
import '../models/settings_model.dart';

abstract interface class SettingsRepository {
  SettingsModel getSettings();

  Future<void> saveSettings(SettingsModel settingsModel);
}

class SettingsRepositoryImpl implements SettingsRepository {
  final LocalData _localData;

  SettingsRepositoryImpl({required LocalData localData})
    : _localData = localData;

  @override
  SettingsModel getSettings() => _localData.getSettings();

  @override
  Future<void> saveSettings(SettingsModel settingsModel) =>
      _localData.saveSettings(settingsModel);
}
