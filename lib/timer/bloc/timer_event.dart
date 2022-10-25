part of 'timer_bloc.dart';

@immutable
abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class TimerStarted extends TimerEvent {
  // const TimerStarted({required this.duration});
  // final int duration; //todo: why duration needed for events?
  const TimerStarted();
}

class TimerTicked extends TimerEvent {
  final int duration;
  const TimerTicked({required this.duration});

  @override
  List<Object> get props => [duration];
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
