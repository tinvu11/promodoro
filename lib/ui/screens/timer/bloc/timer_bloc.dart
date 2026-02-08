import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc()
    : super(
        const TimerInitial(
          duration: _defaultDuration,
          round: 1,
          totalRounds: 1,
        ),
      ) {
    on<TimerStarted>(_onStarted);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
    // on<_TimerTicked>(_onTicked);

    // ✅ THIẾU DÒNG NÀY
    on<TimerSynced>(_onSynced);

    FlutterBackgroundService().on('update').listen((event) {
      if (event != null) {
        add(
          TimerSynced(
            duration: event['current_duration'] as int,
            initialDuration: event['initial_duration'] as int,
            round: event['round'] as int,
            totalRounds: event['total_rounds'] as int,
            isRunning: event['is_running'] as bool,
            mode: (event['mode'] == 'work')
                ? TimerMode.work
                : TimerMode.breakMode,
          ),
        );
      }
    });
    _requestSync();
  }

  void _requestSync() async {
    final service = FlutterBackgroundService();
    if (await service.isRunning()) {
      service.invoke('getState');
    }
  }

  void _onSynced(TimerSynced event, Emitter<TimerState> emit) {
    if (event.isRunning) {
      emit(
        TimerRunInProgress(
          duration: event.duration,
          initialDuration: event.initialDuration,
          round: event.round,
          totalRounds: event.totalRounds,
          mode: event.mode,
        ),
      );
    } else if (event.duration < event.initialDuration &&
        event.initialDuration > 0) {
      emit(
        TimerRunPause(
          duration: event.duration,
          initialDuration: event.initialDuration,
          round: event.round,
          totalRounds: event.totalRounds,
          mode: event.mode,
        ),
      );
    } else {
      // nếu không chạy và chưa từng start, để Initial
      emit(
        TimerInitial(
          duration: _workDuration > 0 ? _workDuration : _defaultDuration,
          round: 1,
          totalRounds: _totalRounds,
        ),
      );
    }
  }

  static const int _defaultDuration = 60;

  int _workDuration = 0;
  int _breakDuration = 0;
  int _totalRounds = 1;

  Future<void> _onStarted(TimerStarted event, Emitter<TimerState> emit) async {
    _workDuration = event.workDuration;
    _breakDuration = event.breakDuration;
    _totalRounds = event.totalRounds;

    emit(
      TimerRunInProgress(
        duration: event.workDuration,
        mode: TimerMode.work,
        round: 1,
        totalRounds: _totalRounds,
        initialDuration: event.workDuration,
      ),
    );

    final service = FlutterBackgroundService();
    if (!await service.isRunning()) {
      await service.startService();
      await Future.delayed(const Duration(milliseconds: 300));
    }

    // ✅ GỬI FULL CONFIG
    service.invoke('startTimer', {
      'duration': event.workDuration,
      'initialDuration': event.workDuration,
      'workDuration': _workDuration,
      'breakDuration': _breakDuration,
      'round': 1,
      'totalRounds': _totalRounds,
      'mode': 'work',
    });
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress) {
      FlutterBackgroundService().invoke('pauseTimer');
      emit(
        TimerRunPause(
          duration: state.duration,
          mode: state.mode,
          round: state.round,
          totalRounds: state.totalRounds,
          initialDuration: state.initialDuration,
        ),
      );
    }
  }

  void _onResumed(TimerResumed event, Emitter<TimerState> emit) {
    if (state is TimerRunPause) {
      // ✅ RESUME bằng event riêng
      FlutterBackgroundService().invoke('resumeTimer');
      emit(
        TimerRunInProgress(
          duration: state.duration,
          mode: state.mode,
          round: state.round,
          totalRounds: state.totalRounds,
          initialDuration: state.initialDuration,
        ),
      );
    }
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    FlutterBackgroundService().invoke('stopService');
    emit(
      TimerInitial(
        duration: _workDuration > 0 ? _workDuration : _defaultDuration,
        round: 1,
        totalRounds: _totalRounds,
      ),
    );
  }

  // _onTicked: nếu bạn đã cho loop sang service rồi thì phần chuyển work/break trong bloc có thể bỏ
}
