import 'package:equatable/equatable.dart';
import 'package:promodoro/data/models/settings_model.dart';

final class SettingsState extends Equatable {
  final SettingsModel settingsModel;
  const SettingsState({required this.settingsModel});
  @override
  List<Object?> get props => [settingsModel];
}

// final class InitialSettingsState extends SettingsState {}
//
// final class LoadingSettingsState extends SettingsState {}
//
// final class SuccessSettingState extends SettingsState {
//   final SettingsModel settingsModel;
//   SuccessSettingState({required this.settingsModel});
//   @override
//   List<Object?> get props => [settingsModel];
// }
//
// final class ErrorSettingsState extends SettingsState {
//   final String message;
//   ErrorSettingsState({required this.message});
//   @override
//   List<Object?> get props => [message];
// }
