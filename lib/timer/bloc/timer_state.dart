part of 'timer_bloc.dart';

@immutable
abstract class TimerState extends Equatable {
  final int durationInSeconds;
  const TimerState(this.durationInSeconds);

  @override
  List<Object> get props => [durationInSeconds];
}

class TimerInitial extends TimerState {
  const TimerInitial(super.durationInSeconds);

  @override
  String toString() => 'TimerInitial { duration: $durationInSeconds }';
}

class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(super.durationInSeconds);

  @override
  String toString() => 'TimerRunInProgress { duration: $durationInSeconds }';
}

class TimerRunPause extends TimerState {
  const TimerRunPause(super.durationInSeconds);

  @override
  String toString() => 'TimerRunPause { duration: $durationInSeconds }';
}

class TimerRunComplete extends TimerState {
  const TimerRunComplete() : super(0);

  @override
  String toString() {
    return 'TimerRunComplete { duration: $durationInSeconds }';
  }
}

class TimerInitialAfterPause extends TimerState {
  const TimerInitialAfterPause(super.durationInSeconds);

  @override
  String toString() =>
      'TimerInitialAfterPause { duration: $durationInSeconds }';
}

class TimerInitialWhileRunning extends TimerState {
  const TimerInitialWhileRunning(super.durationInSeconds);

  @override
  String toString() =>
      'TimerInitialWhileRunning { duration: $durationInSeconds }';
}
