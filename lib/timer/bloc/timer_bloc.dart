import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_timer/ticker.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  static int initialDuration = 7 * 60;
  final Ticker _ticker;

  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(TimerInitial(initialDuration)) {
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
    emit(TimerRunInProgress(event.duration));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tickWithStreamPeriodic(ticks: event.duration)
        // .tickWithYield(event.duration)
        .listen((duration) => add(TimerTicked(duration: duration)));
  }

  void _onTicked(TimerTicked event, emit) {
    emit(event.duration > 0
        ? TimerRunInProgress(event.duration)
        : const TimerRunComplete());
  }

  void _onPaused(event, emit) {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      emit(TimerRunPause(state.duration));
    }
  }

  void _onResumed(event, emit) {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(state.duration));
    }
  }

  void _onReset(event, emit) {
    _tickerSubscription?.cancel();
    emit(TimerInitial(initialDuration));
  }

  void _onPausedAndReset(event, emit) {
    _tickerSubscription?.cancel();
    emit(TimerInitialAfterPause(initialDuration));
  }

  void _onRunningAndReset(event, emit) {
    _tickerSubscription?.cancel();
    emit(TimerInitialWhileRunning(initialDuration));
  }

  void _onChanged(TimerChanged event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    initialDuration = event.newDuration;
    emit(TimerInitial(event.newDuration));
  }
}
