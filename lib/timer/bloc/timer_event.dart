part of 'timer_bloc.dart';

@immutable
abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class TimerStarted extends TimerEvent {
  const TimerStarted({required this.durationInSeconds});
  final int durationInSeconds;
}

class TimerTicked extends TimerEvent {
  final int durationInSeconds;
  const TimerTicked({required this.durationInSeconds});

  @override
  List<Object> get props => [durationInSeconds];
}

class TimerPaused extends TimerEvent {
  const TimerPaused();
}

class TimerResumed extends TimerEvent {
  const TimerResumed();
}

class TimerReset extends TimerEvent {
  const TimerReset();
}

class TimerPausedAndReset extends TimerEvent {
  const TimerPausedAndReset();
}

class TimerRunningAndReset extends TimerEvent {
  const TimerRunningAndReset();
}

class TimerChanged extends TimerEvent {
  const TimerChanged({required this.newDurationInSeconds});
  final int newDurationInSeconds;
}
