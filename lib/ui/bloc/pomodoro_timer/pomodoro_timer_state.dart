import 'package:equatable/equatable.dart';

class PomodoroTimerState extends Equatable {
  final int status; // 0: initial, 1: running, 2: paused, 3: finished
  final int session; // 0: work, 1: shortBreak, 2: longBreak
  final int remainingSeconds;
  final int cycle;

  const PomodoroTimerState({
    required this.status,
    required this.session,
    required this.remainingSeconds,
    required this.cycle,
  });

  factory PomodoroTimerState.initial() {
    return const PomodoroTimerState(
      status: 0,
      session: 0,
      remainingSeconds: 25 * 60,
      cycle: 1,
    );
  }

  PomodoroTimerState copyWith({
    int? status,
    int? session,
    int? remainingSeconds,
    int? cycle,
  }) {
    return PomodoroTimerState(
      status: status ?? this.status,
      session: session ?? this.session,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      cycle: cycle ?? this.cycle,
    );
  }

  @override
  List<Object?> get props => [status, session, remainingSeconds, cycle];
}
