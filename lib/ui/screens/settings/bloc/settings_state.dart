part of 'settings_bloc.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();
  @override
  List<Object?> get props => [];
}

final class InitialSettingsState extends SettingsState {}

//
// final class LoadingSettingsState extends SettingsState {}
//
final class SuccessSettingState extends SettingsState {
  final SettingsModel settingsModel;
  const SuccessSettingState({required this.settingsModel});
  SuccessSettingState copyWith({SettingsModel? settingsModel}) {
    return SuccessSettingState(settingsModel: settingsModel ?? this.settingsModel);
  }

  @override
  List<Object?> get props => [settingsModel];
}

//
// final class ErrorSettingsState extends SettingsState {
//   final String message;
//   ErrorSettingsState({required this.message});
//   @override
//   List<Object?> get props => [message];
// }
