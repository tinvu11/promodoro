part of 'static_bloc.dart';

sealed class StaticState extends Equatable {
  const StaticState();

  @override
  List<Object?> get props => [];
}

final class StaticInitial extends StaticState {}

final class StaticLoading extends StaticState {}

final class StaticLoaded extends StaticState {
  final List<DailyStat> allStats;
  final DailyStat todayStat;
  final int totalMinutes;
  final int totalSessions;

  const StaticLoaded({
    required this.allStats,
    required this.todayStat,
    required this.totalMinutes,
    required this.totalSessions,
  });

  StaticLoaded copyWith({
    List<DailyStat>? allStats,
    DailyStat? todayStat,
    int? totalMinutes,
    int? totalSessions,
  }) {
    return StaticLoaded(
      allStats: allStats ?? this.allStats,
      todayStat: todayStat ?? this.todayStat,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      totalSessions: totalSessions ?? this.totalSessions,
    );
  }

  @override
  List<Object?> get props => [allStats, todayStat, totalMinutes, totalSessions];
}

final class StaticError extends StaticState {
  final String message;

  const StaticError({required this.message});

  @override
  List<Object?> get props => [message];
}
