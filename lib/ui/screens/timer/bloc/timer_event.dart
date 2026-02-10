part of 'timer_bloc.dart';

sealed class TimerEvent {
  const TimerEvent();
}

final class TimerStarted extends TimerEvent {
  const TimerStarted({
    required this.workDuration,
    required this.breakDuration,
    required this.totalRounds,
    required this.alarmWorkPath,
    required this.alarmBreakPath,
  });
  final int workDuration;
  final int breakDuration;
  final int totalRounds;
  final String alarmWorkPath;
  final String alarmBreakPath;
}

final class TimerPaused extends TimerEvent {
  const TimerPaused();
}

final class TimerResumed extends TimerEvent {
  const TimerResumed();
}

class TimerReset extends TimerEvent {
  const TimerReset();
}

class TimerSynced extends TimerEvent {
  const TimerSynced({
    required this.duration,
    required this.initialDuration,
    required this.round,
    required this.totalRounds,
    required this.isRunning,
    required this.mode,
  });
  final int duration;
  final int initialDuration;
  final int round;
  final int totalRounds;
  final bool isRunning;
  final TimerMode mode;
}

class TimerFinished extends TimerEvent {
  const TimerFinished();
}

class _TimerTicked extends TimerEvent {
  const _TimerTicked({required this.duration});
  final int duration;
}

class _LocalTick extends TimerEvent {
  const _LocalTick();
}
