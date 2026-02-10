import 'package:hive_ce/hive.dart';
import 'package:intl/intl.dart';

import '../../configs/hive/hive_types.dart';

part 'daily_stat.g.dart';

@HiveType(typeId: HiveTypes.dailyStat)
class DailyStat {
  @HiveField(0)
  final DateTime date;
  @HiveField(1)
  int minutes;
  @HiveField(2)
  int sessions;

  DailyStat({required this.date, this.minutes = 0, this.sessions = 0});

  String get id => DateFormat('yyyy-MM-dd').format(date);

  String get dayOfMonth => date.day.toString();

  DailyStat copyWith({int? minutes, int? sessions}) {
    return DailyStat(
      date: date,
      minutes: minutes ?? this.minutes,
      sessions: sessions ?? this.sessions,
    );
  }
}
