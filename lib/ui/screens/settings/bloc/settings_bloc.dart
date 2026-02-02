import 'package:bloc/bloc.dart';
import 'package:promodoro/data/data_sources/local_data.dart';
import 'package:promodoro/ui/screens/settings/bloc/settings_event.dart';
import 'package:promodoro/ui/screens/settings/bloc/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final LocalData localData;
  SettingsBloc({required this.localData}) : super(SettingsState(settingsModel: localData.getSettings())) {
    on<GetSettingsEvent>(_onGetSettings);
    on<SaveSettingsEvent>(_onSaveSettings);
  }

  Future<void> _onGetSettings(GetSettingsEvent event, Emitter<SettingsState> emit) async {
    final settingsModel = localData.getSettings();
    emit(SettingsState(settingsModel: settingsModel));
  }

  Future<void> _onSaveSettings(SaveSettingsEvent event, Emitter<SettingsState> emit) async {
    await localData.saveSettings(event.settingsModel);
    emit(SettingsState(settingsModel: event.settingsModel));
  }
}
