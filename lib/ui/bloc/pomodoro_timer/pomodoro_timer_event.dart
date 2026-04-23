import 'package:equatable/equatable.dart';

abstract class PomodoroTimerEvent extends Equatable {
  const PomodoroTimerEvent();

  @override
  List<Object?> get props => [];
}

class PomodoroTimerStarted extends PomodoroTimerEvent {}

class PomodoroTimerPaused extends PomodoroTimerEvent {}

class PomodoroTimerResumed extends PomodoroTimerEvent {}

class PomodoroTimerReset extends PomodoroTimerEvent {}

class PomodoroTimerNext extends PomodoroTimerEvent {}

class PomodoroTimerSettingsUpdated extends PomodoroTimerEvent {
  final Map<String, dynamic> settings;
  const PomodoroTimerSettingsUpdated(this.settings);
  @override
  List<Object?> get props => [settings];
}

class PomodoroTimerTick extends PomodoroTimerEvent {
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
