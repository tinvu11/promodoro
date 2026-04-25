part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object?> get props => [];
}

class PomodoroTimerStarted extends TimerEvent {}

class PomodoroTimerPaused extends TimerEvent {}

class PomodoroTimerResumed extends TimerEvent {}

class PomodoroTimerReset extends TimerEvent {}

class PomodoroTimerNext extends TimerEvent {}

class PomodoroTimerSettingsUpdated extends TimerEvent {
  final Map<String, dynamic> settings;
  const PomodoroTimerSettingsUpdated(this.settings);
  @override
  List<Object?> get props => [settings];
}

class PomodoroTimerTick extends TimerEvent {
  final int status;
  final int session;
  final int remainingSeconds;
  final int cycle;

  const PomodoroTimerTick(
    this.status,
    this.session,
    this.remainingSeconds,
    this.cycle,
  );

  @override
  List<Object?> get props => [status, session, remainingSeconds, cycle];
}
