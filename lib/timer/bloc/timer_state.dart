part of 'timer_bloc.dart';

@immutable
abstract class TimerState extends Equatable {
  final int duration;
  const TimerState(this.duration);

  @override
  List<Object> get props => [duration];
}

class TimerInitial extends TimerState {
  const TimerInitial(super.duration);

  @override
  String toString() => 'TimerInitial { duration: $duration }';
}

class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(super.duration);

  @override
  String toString() => 'TimerRunInProgress { duration: $duration }';
}

class TimerRunPause extends TimerState {
  const TimerRunPause(super.duration);

  @override
  String toString() => 'TimerRunPause { duration: $duration }';
}

class TimerRunComplete extends TimerState {
  const TimerRunComplete() : super(0);

  @override
  String toString() {
    return 'TimerRunComplete { duration: $duration }';
  }
}

class TimerInitialAfterPause extends TimerState {
  const TimerInitialAfterPause(super.duration);

  @override
  String toString() => 'TimerInitialAfterPause { duration: $duration }';
}

class TimerInitialWhileRunning extends TimerState {
  const TimerInitialWhileRunning(super.duration);

  @override
  String toString() => 'TimerInitialWhileRunning { duration: $duration }';
}
