import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import '../../../services/pomodoro_background_service.dart';
import 'pomodoro_timer_event.dart';
import 'pomodoro_timer_state.dart';

class PomodoroTimerBloc extends Bloc<PomodoroTimerEvent, PomodoroTimerState> {
  final PomodoroBackgroundService _service = PomodoroBackgroundService();
  StreamSubscription? _serviceSubscription;

  PomodoroTimerBloc() : super(PomodoroTimerState.initial()) {
    on<PomodoroTimerStarted>(_onStarted);
    on<PomodoroTimerPaused>(_onPaused);
    on<PomodoroTimerResumed>(_onResumed);
    on<PomodoroTimerReset>(_onReset);
    on<PomodoroTimerNext>(_onNext);
    on<PomodoroTimerSettingsUpdated>(_onSettingsUpdated);
    on<PomodoroTimerTick>(_onTick);

    _serviceSubscription = FlutterBackgroundService().on('update').listen((event) {
      if (event != null) {
        add(PomodoroTimerTick(
          event['status'] as int,
          event['session'] as int,
          event['remainingSeconds'] as int,
          event['cycle'] as int,
        ));
      }
    });

    _service.requestState();
  }

  void _onStarted(PomodoroTimerStarted event, Emitter<PomodoroTimerState> emit) {
    _service.start();
  }

  void _onPaused(PomodoroTimerPaused event, Emitter<PomodoroTimerState> emit) {
    _service.pause();
  }

  void _onResumed(PomodoroTimerResumed event, Emitter<PomodoroTimerState> emit) {
    _service.resume();
  }

  void _onReset(PomodoroTimerReset event, Emitter<PomodoroTimerState> emit) {
    _service.reset();
  }

  void _onNext(PomodoroTimerNext event, Emitter<PomodoroTimerState> emit) {
    _service.next();
  }

  void _onSettingsUpdated(PomodoroTimerSettingsUpdated event, Emitter<PomodoroTimerState> emit) {
    _service.setSettings(event.settings);
  }

  void _onTick(PomodoroTimerTick event, Emitter<PomodoroTimerState> emit) {
    emit(state.copyWith(
      status: event.status,
      session: event.session,
      remainingSeconds: event.remainingSeconds,
      cycle: event.cycle,
    ));
  }

  @override
  Future<void> close() {
    _serviceSubscription?.cancel();
    return super.close();
  }
}
