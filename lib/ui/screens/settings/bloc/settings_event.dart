part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class GetSettingsEvent extends SettingsEvent {}

final class SaveSettingsEvent extends SettingsEvent {
  final int? workTime;
  final int? breakTime;
  final int? repeatCount;
  final bool? isSoundEnabled;
  final String? selectedThemeId;
  final String? alarmWork;
  final String? alarmBreak;
  final double? volumeWorkAlarm;
  final double? volumeBreakAlarm;
  final double? volumeNoise;
  final bool? alwaysOnScreen;

  SaveSettingsEvent({
    this.workTime,
    this.breakTime,
    this.repeatCount,
    this.isSoundEnabled,
    this.selectedThemeId,
    this.alarmWork,
    this.alarmBreak,
    this.volumeWorkAlarm,
    this.volumeBreakAlarm,
    this.volumeNoise,
    this.alwaysOnScreen,
  });

  @override
  List<Object?> get props => [
    workTime,
    breakTime,
    repeatCount,
    isSoundEnabled,
    selectedThemeId,
    alarmWork,
    alarmBreak,
    volumeWorkAlarm,
    volumeBreakAlarm,
    volumeNoise,
    alwaysOnScreen,
  ];
}
