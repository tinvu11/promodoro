import '../data_sources/local_data.dart';
import '../models/daily_stat.dart';

abstract interface class StatRepository {
  List<DailyStat> getAllDailyStats();

  List<DailyStat> getDailyStatByMonth(int year, int month);

  DailyStat getDailyStatByDate(DateTime date);

  int getTotalMinutes();

  int getTotalSessions();

  Future<void> saveDailyStat(DailyStat dailyStat);
}

class StatRepositoryImpl implements StatRepository {
  final LocalData _localData;

  StatRepositoryImpl({required LocalData localData}) : _localData = localData;

  @override
  List<DailyStat> getAllDailyStats() => _localData.getDailyStat();

  @override
  List<DailyStat> getDailyStatByMonth(int year, int month) =>
      _localData.getDailyStatByMonth(year, month);

  @override
  DailyStat getDailyStatByDate(DateTime date) =>
      _localData.getDailyStatByDate(date);

  @override
  int getTotalMinutes() => _localData.getTotalMinutes();

  @override
  int getTotalSessions() => _localData.getTotalSessions();

  @override
  Future<void> saveDailyStat(DailyStat dailyStat) =>
      _localData.saveDailyStat(dailyStat);
}
