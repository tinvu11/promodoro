part of 'timer_bloc.dart';

enum TimerMode { work, breakMode }

sealed class TimerState extends Equatable {
  const TimerState({
    required this.duration,
    required this.mode,
    required this.round,
    required this.totalRounds,
    required this.initialDuration,
  });

  final int duration;
  final TimerMode mode;
  final int round;
  final int totalRounds;
  final int initialDuration;

  @override
  List<Object> get props => [
    duration,
    mode,
    round,
    totalRounds,
    initialDuration,
  ];
}

final class TimerInitial extends TimerState {
  const TimerInitial({
    required super.duration,
    required super.round,
    required super.totalRounds,
    super.mode = TimerMode.work, // Thêm default mode để không bị lỗi required
    super.initialDuration = 0, // Thêm default nếu cần
  });

  @override
  String toString() => 'TimerInitial { duration: $duration }';
}

final class TimerRunPause extends TimerState {
  // Dùng super. thẳng trong tham số, bỏ sạch phần : super(...) phía sau
  const TimerRunPause({
    required super.duration,
    required super.mode,
    required super.round,
    required super.totalRounds,
    required super.initialDuration,
  });

  @override
  String toString() => 'TimerRunPause { duration: $duration }';
}

final class TimerRunInProgress extends TimerState {
  const TimerRunInProgress({
    required super.duration,
    required super.mode,
    required super.round,
    required super.totalRounds,
    required super.initialDuration,
  });

  @override
  String toString() => 'TimerRunInProgress { duration: $duration }';
}

final class TimerRunComplete extends TimerState {
  const TimerRunComplete({
    required super.round,
    required super.totalRounds,
    required super.initialDuration,
  }) : super(duration: 0, mode: TimerMode.work);
}
