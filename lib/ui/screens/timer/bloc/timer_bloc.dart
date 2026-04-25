import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:pomodoro/services/timer_background_service.dart';
import 'package:equatable/equatable.dart';
part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final PomodoroBackgroundService _service = PomodoroBackgroundService();
  StreamSubscription? _serviceSubscription;

  TimerBloc() : super(TimerState.initial()) {
    on<PomodoroTimerStarted>(_onStarted);
    on<PomodoroTimerPaused>(_onPaused);
    on<PomodoroTimerResumed>(_onResumed);
    on<PomodoroTimerReset>(_onReset);
    on<PomodoroTimerNext>(_onNext);
    on<PomodoroTimerSettingsUpdated>(_onSettingsUpdated);
    on<PomodoroTimerTick>(_onTick);

    _serviceSubscription = FlutterBackgroundService().on('update').listen((
      event,
    ) {
      if (event != null) {
        add(
          PomodoroTimerTick(
            event['status'] as int,
            event['session'] as int,
            event['remainingSeconds'] as int,
            event['cycle'] as int,
          ),
        );
      }
    });

    _service.requestState();
  }

  void _onStarted(PomodoroTimerStarted event, Emitter<TimerState> emit) async {
    await _service.start();
  }

  void _onPaused(PomodoroTimerPaused event, Emitter<TimerState> emit) {
    _service.pause();
  }

  void _onResumed(PomodoroTimerResumed event, Emitter<TimerState> emit) {
    _service.resume();
  }

  void _onReset(PomodoroTimerReset event, Emitter<TimerState> emit) {
    _service.reset();
  }

  void _onNext(PomodoroTimerNext event, Emitter<TimerState> emit) {
    _service.next();
  }

  void _onSettingsUpdated(
    PomodoroTimerSettingsUpdated event,
    Emitter<TimerState> emit,
  ) async {
    await _service.setSettings(event.settings);
  }

  void _onTick(PomodoroTimerTick event, Emitter<TimerState> emit) {
    emit(
      state.copyWith(
        status: event.status,
        session: event.session,
        remainingSeconds: event.remainingSeconds,
        cycle: event.cycle,
      ),
    );
  }

  @override
  Future<void> close() {
    _serviceSubscription?.cancel();
    return super.close();
  }
}
