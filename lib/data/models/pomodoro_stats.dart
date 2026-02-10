import 'package:hive_ce/hive.dart';

import '../../configs/hive/hive_types.dart';
import 'daily_stat.dart';

part 'pomodoro_stats.g.dart';

@HiveType(typeId: HiveTypes.pomodoroStats)
class PomodoroStats {
  @HiveField(0)
  int totalAllTimeMinutes;
  @HiveField(1)
  int totalAllTimeSessions;

  PomodoroStats({this.totalAllTimeMinutes = 0, this.totalAllTimeSessions = 0});

  PomodoroStats copyWith({
    int? totalAllTimeMinutes,
    int? totalAllTimeSessions,
  }) {
    return PomodoroStats(
      totalAllTimeMinutes: totalAllTimeMinutes ?? this.totalAllTimeMinutes,
      totalAllTimeSessions: totalAllTimeSessions ?? this.totalAllTimeSessions,
    );
  }
}
