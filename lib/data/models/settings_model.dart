import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart';
import '../../configs/hive/hive_types.dart';
import 'alarm_model.dart';

part 'settings_model.g.dart';

@HiveType(typeId: HiveTypes.settings)
class SettingsModel extends HiveObject with EquatableMixin {
  @HiveField(0)
  final int workTime;

  @HiveField(1)
  final int breakTime;

  @HiveField(2)
  final int repeatCount;

  @HiveField(3)
  final bool isSoundEnabled;

  @HiveField(4)
  final String selectedThemeId;

  @HiveField(5)
  final AlarmModel alarmWork; // Đường dẫn âm báo khi xong việc

  @HiveField(6)
  final AlarmModel alarmBreak; // Đường dẫn âm báo khi xong nghỉ

  @HiveField(7)
  final double volumeWorkAlarm;

  @HiveField(8)
  final double volumeBreakAlarm;

  @HiveField(9)
  final double volumeNoise;

  @HiveField(10)
  final bool alwaysOnScreen;

  SettingsModel({
    required this.workTime,
    required this.breakTime,
    required this.repeatCount,
    required this.isSoundEnabled,
    required this.selectedThemeId,
    required this.alarmWork,
    required this.alarmBreak,
    required this.volumeWorkAlarm,
    required this.volumeBreakAlarm,
    required this.volumeNoise,
    required this.alwaysOnScreen,
  });

  SettingsModel copyWith({
    int? workTime,
    int? breakTime,
    int? repeatCount,
    bool? isSoundEnabled,
    String? selectedThemeId,
    AlarmModel? alarmWork,
    AlarmModel? alarmBreak,
    double? volumeWorkAlarm,
    double? volumeBreakAlarm,
    double? volumeNoise,
    bool? alwaysOnScreen,
  }) {
    return SettingsModel(
      workTime: workTime ?? this.workTime,
      breakTime: breakTime ?? this.breakTime,
      repeatCount: repeatCount ?? this.repeatCount,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      selectedThemeId: selectedThemeId ?? this.selectedThemeId,
      alarmWork: alarmWork ?? this.alarmWork,
      alarmBreak: alarmBreak ?? this.alarmBreak,
      volumeWorkAlarm: volumeWorkAlarm ?? this.volumeWorkAlarm,
      volumeBreakAlarm: volumeBreakAlarm ?? this.volumeBreakAlarm,
      volumeNoise: volumeNoise ?? this.volumeNoise,
      alwaysOnScreen: alwaysOnScreen ?? this.alwaysOnScreen,
    );
  }

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
