import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:promodoro/data/repositories/settings_repository.dart';

import '../../../../data/models/alarm_model.dart';
import '../../../../data/models/settings_model.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;
  SettingsBloc({required this.settingsRepository})
    : super(InitialSettingsState()) {
    on<GetSettingsEvent>(_onGetSettings);
    on<SaveSettingsEvent>(_onSaveSettings);
  }

  Future<void> _onGetSettings(
    GetSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final settingsModel = settingsRepository.getSettings();
    emit(SuccessSettingState(settingsModel: settingsModel));
  }

  Future<void> _onSaveSettings(
    SaveSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is! SuccessSettingState) return;
    final currentState = state as SuccessSettingState;
    final currentModel = currentState.settingsModel;

    final updatedModel = currentModel.copyWith(
      workTime: event.workTime ?? currentModel.workTime,
      breakTime: event.breakTime ?? currentModel.breakTime,
      repeatCount: event.repeatCount ?? currentModel.repeatCount,
      isSoundEnabled: event.isSoundEnabled ?? currentModel.isSoundEnabled,
      selectedThemeId: event.selectedThemeId ?? currentModel.selectedThemeId,
      alarmWork: event.alarmWork ?? currentModel.alarmWork,
      alarmBreak: event.alarmBreak ?? currentModel.alarmBreak,
      volumeWorkAlarm: event.volumeWorkAlarm ?? currentModel.volumeWorkAlarm,
      volumeBreakAlarm: event.volumeBreakAlarm ?? currentModel.volumeBreakAlarm,
      volumeNoise: event.volumeNoise ?? currentModel.volumeNoise,
      alwaysOnScreen: event.alwaysOnScreen ?? currentModel.alwaysOnScreen,
    );
    emit(currentState.copyWith(settingsModel: updatedModel));
    await settingsRepository.saveSettings(updatedModel);
  }
}
