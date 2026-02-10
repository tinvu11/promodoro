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
  List<Object> get props => [duration, mode, round, totalRounds, initialDuration];
}

final class TimerInitial extends TimerState {
  const TimerInitial({
    required int duration,
    required int round,
    required int totalRounds,
  }) : super(
          duration: duration,
          mode: TimerMode.work,
          round: round,
          totalRounds: totalRounds,
          initialDuration: duration,
        );

  @override
  String toString() => 'TimerInitial { duration: $duration }';
}

final class TimerRunPause extends TimerState {
  const TimerRunPause({
    required int duration,
    required TimerMode mode,
    required int round,
    required int totalRounds,
    required int initialDuration,
  }) : super(
          duration: duration,
          mode: mode,
          round: round,
          totalRounds: totalRounds,
          initialDuration: initialDuration,
        );

  @override
  String toString() => 'TimerRunPause { duration: $duration }';
}

final class TimerRunInProgress extends TimerState {
  const TimerRunInProgress({
    required int duration,
    required TimerMode mode,
    required int round,
    required int totalRounds,
    required int initialDuration,
  }) : super(
          duration: duration,
          mode: mode,
          round: round,
          totalRounds: totalRounds,
          initialDuration: initialDuration,
        );

  @override
  String toString() => 'TimerRunInProgress { duration: $duration }';
}

final class TimerRunComplete extends TimerState {
  const TimerRunComplete({
    required int round,
    required int totalRounds,
  }) : super(
          duration: 0,
          mode: TimerMode.work,
          round: round,
          totalRounds: totalRounds,
          initialDuration: 0,
        );
}
