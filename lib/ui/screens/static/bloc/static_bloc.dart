import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart';
import 'package:pomodoro/configs/hive/app_hive.dart';
import 'package:pomodoro/data/repositories/stat_repository.dart';
import '../../../../data/models/daily_stat.dart';

part 'static_event.dart';
part 'static_state.dart';

class StaticBloc extends Bloc<StaticEvent, StaticState> {
  final StatRepository statRepository;

  StaticBloc({required this.statRepository}) : super(StaticInitial()) {
    on<LoadStaticEvent>(_onLoadStatic);
    on<RefreshStaticEvent>(_onRefreshStatic);
    on<SeedSampleDataEvent>(_onSeedSampleData);
  }

  Future<void> _onLoadStatic(
    LoadStaticEvent event,
    Emitter<StaticState> emit,
  ) async {
    emit(StaticLoading());
    try {
      final now = DateTime.now();

      final allStats = List<DailyStat>.from(statRepository.getAllDailyStats())
        ..sort((a, b) => a.date.compareTo(b.date));
      final todayStat = statRepository.getDailyStatByDate(now);
      final totalMinutes = statRepository.getTotalMinutes();
      final totalSessions = statRepository.getTotalSessions();

      emit(
        StaticLoaded(
          allStats: allStats,
          todayStat: todayStat,
          totalMinutes: totalMinutes,
          totalSessions: totalSessions,
        ),
      );
    } catch (e) {
      emit(StaticError(message: e.toString()));
    }
  }

  // refresh data khi người dùng kéo xuống để refresh
  Future<void> _onRefreshStatic(
    RefreshStaticEvent event,
    Emitter<StaticState> emit,
  ) async {
    try {
      // Reload box from disk because background isolate might have updated it
      if (Hive.isBoxOpen(AppHive.dailyStatisKey)) {
        await Hive.box<DailyStat>(AppHive.dailyStatisKey).close();
      }
      await Hive.openBox<DailyStat>(AppHive.dailyStatisKey);
      final now = DateTime.now();
      final allStats = List<DailyStat>.from(statRepository.getAllDailyStats())
        ..sort((a, b) => a.date.compareTo(b.date));
      final todayStat = statRepository.getDailyStatByDate(now);
      final totalMinutes = statRepository.getTotalMinutes();
      final totalSessions = statRepository.getTotalSessions();

      emit(
        StaticLoaded(
          allStats: allStats,
          todayStat: todayStat,
          totalMinutes: totalMinutes,
          totalSessions: totalSessions,
        ),
      );
    } catch (e) {
      emit(StaticError(message: e.toString()));
    }
  }

  Future<void> _onSeedSampleData(
    SeedSampleDataEvent event,
    Emitter<StaticState> emit,
  ) async {
    final random = Random();
    final now = DateTime.now();

    // Xác định mốc thời gian bắt đầu là 60 ngày trước
    final startDate = now.subtract(const Duration(days: 15));

    List<Future> saveOperations = [];

    for (int i = 0; i <= 60; i++) {
      // Từ ngày bắt đầu, cộng thêm i ngày để tiến dần đến hôm nay
      final date = startDate.add(Duration(days: i));

      // Đảm bảo không tạo dữ liệu cho tương lai (phòng hờ)
      if (date.isAfter(now)) break;

      // Random dữ liệu thực tế:
      // Thường thì cuối tuần làm ít hơn, ngày thường làm nhiều hơn
      final isWeekend =
          date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
      final minutes = isWeekend ? random.nextInt(60) : 60 + random.nextInt(180);
      final sessions = (minutes / 25).ceil();

      final stat = DailyStat(date: date, minutes: minutes, sessions: sessions);

      saveOperations.add(statRepository.saveDailyStat(stat));
    }

    // Đợi Hive ghi xong toàn bộ "lịch sử"
    await Future.wait(saveOperations);

    // Load lại để cập nhật UI ngay lập tức
    add(LoadStaticEvent());
  }
}
