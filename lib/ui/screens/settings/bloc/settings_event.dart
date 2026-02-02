import 'package:equatable/equatable.dart';
import 'package:promodoro/data/models/settings_model.dart';

sealed class SettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class GetSettingsEvent extends SettingsEvent {}

final class SaveSettingsEvent extends SettingsEvent {
  final SettingsModel settingsModel;
  SaveSettingsEvent({required this.settingsModel});

  @override
  List<Object?> get props => [settingsModel];
}
