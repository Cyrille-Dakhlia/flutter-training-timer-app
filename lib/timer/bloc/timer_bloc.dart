import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_timer/ticker.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  static int initialDurationInSeconds = 7 * 60;
  final Ticker _ticker;

  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(TimerInitial(initialDurationInSeconds)) {
    on<TimerStarted>(_onStarted);
    on<TimerTicked>(_onTicked);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
    on<TimerPausedAndReset>(_onPausedAndReset);
    on<TimerRunningAndReset>(_onRunningAndReset);
    on<TimerChanged>(_onChanged);
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, emit) {
    emit(TimerRunInProgress(event.durationInSeconds));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tickWithStreamPeriodic(ticks: event.durationInSeconds)
        // .tickWithYield(event.duration)
        .listen((duration) => add(TimerTicked(durationInSeconds: duration)));
  }

  void _onTicked(TimerTicked event, emit) {
    emit(event.durationInSeconds > 0
        ? TimerRunInProgress(event.durationInSeconds)
        : const TimerRunComplete());
  }

  void _onPaused(event, emit) {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      emit(TimerRunPause(state.durationInSeconds));
    }
  }

  void _onResumed(event, emit) {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(state.durationInSeconds));
    }
  }

  void _onReset(event, emit) {
    _tickerSubscription?.cancel();
    emit(TimerInitial(initialDurationInSeconds));
  }

  void _onPausedAndReset(event, emit) {
    _tickerSubscription?.cancel();
    emit(TimerInitialAfterPause(initialDurationInSeconds));
  }

  void _onRunningAndReset(event, emit) {
    _tickerSubscription?.cancel();
    emit(TimerInitialWhileRunning(initialDurationInSeconds));
  }

  void _onChanged(TimerChanged event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    initialDurationInSeconds = event.newDurationInSeconds;
    emit(TimerInitial(event.newDurationInSeconds));
  }
}
