import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_timer/app.dart';
import 'package:flutter_timer/ticker.dart';
import 'package:flutter_timer/timer/timer.dart';

void main() {
  // Write test, then run "flutter test --update-goldens" to generate golden img
  testWidgets('should golden test TimerPage screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(TimerApp());

    final foundTimerPage = find.byType(TimerPage);

    expectLater(foundTimerPage, matchesGoldenFile('goldens/timer_page.png'));
  });

  group('TimerBloc', () {
    late TimerBloc timerBloc;

    setUp(() => timerBloc = TimerBloc(ticker: Ticker()));

    test('initial state is TimerInitial',
        () => expect(timerBloc.state.runtimeType, TimerInitial));

    blocTest<TimerBloc, TimerState>(
      'emits [TimerRunInProgress] with the same duration when TimerStarted is triggered',
      build: () => timerBloc,
      act: (bloc) => bloc.add(TimerStarted(durationInSeconds: 1)),
      expect: () => <TimerState>[TimerRunInProgress(1)],
    );

    blocTest<TimerBloc, TimerState>(
      'emits [TimerRunInProgress] with the same duration when TimerTicked is triggered and duration is more than 0 second',
      build: () => timerBloc,
      act: (bloc) => bloc.add(TimerTicked(durationInSeconds: 2)),
      expect: () => <TimerState>[TimerRunInProgress(2)],
    );

    blocTest<TimerBloc, TimerState>(
      'emits [TimerRunComplete] when TimerTicked is triggered and duration is 0 second',
      build: () => timerBloc,
      act: (bloc) => bloc.add(TimerTicked(durationInSeconds: 0)),
      expect: () => <TimerState>[TimerRunComplete()],
    );

    blocTest<TimerBloc, TimerState>(
      'emits [TimerRunPause] with the same duration when timer is running and TimerPaused is triggered',
      build: () => timerBloc,
      act: (bloc) => bloc
        ..add(TimerStarted(durationInSeconds: 4))
        ..add(TimerPaused()),
      skip: 1,
      expect: () => <TimerState>[TimerRunPause(4)],
    );

    blocTest<TimerBloc, TimerState>(
      'emits [TimerRunInProgress] with the same duration if timer is paused and TimerResumed is triggered',
      build: () => timerBloc,
      act: (bloc) => bloc
        ..add(TimerStarted(durationInSeconds: 5))
        ..add(TimerPaused())
        ..add(TimerResumed()),
      skip: 2,
      expect: () => <TimerState>[TimerRunInProgress(5)],
    );

    blocTest<TimerBloc, TimerState>(
      'emits [TimerInitial] when TimerReset is triggered',
      build: () => timerBloc,
      act: (bloc) => bloc
        ..add(TimerStarted(durationInSeconds: 6))
        ..add(TimerReset()),
      skip: 1,
      expect: () =>
          <TimerState>[TimerInitial(timerBloc.state.durationInSeconds)],
    );

    blocTest<TimerBloc, TimerState>(
      'emits [TimerInitialAfterPause] when timer is paused and TimerPausedAndReset is triggered',
      build: () => timerBloc,
      act: (bloc) => bloc
        ..add(TimerStarted(durationInSeconds: 6))
        ..add(TimerPaused())
        ..add(TimerPausedAndReset()),
      skip: 2,
      expect: () => <TimerState>[
        TimerInitialAfterPause(timerBloc.state.durationInSeconds)
      ],
    );

    blocTest<TimerBloc, TimerState>(
      'emits [TimerInitialWhileRunning] when timer is running and TimerRunningAndReset is triggered',
      build: () => timerBloc,
      act: (bloc) => bloc
        ..add(TimerStarted(durationInSeconds: 6))
        ..add(TimerRunningAndReset()),
      skip: 1,
      expect: () => <TimerState>[
        TimerInitialWhileRunning(timerBloc.state.durationInSeconds)
      ],
    );

    blocTest<TimerBloc, TimerState>(
      'emits [TimerInitial] when timer TimerChanged is triggered',
      build: () => timerBloc,
      act: (bloc) => bloc.add(TimerChanged(newDurationInSeconds: 7)),
      expect: () => <TimerState>[TimerInitial(7)],
    );
  });
}
