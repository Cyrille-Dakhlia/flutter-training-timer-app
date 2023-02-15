import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../../components/stack_animation.dart';
import '../../bloc/timer_bloc.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (previous, current) =>
          current.runtimeType != previous.runtimeType ||
          current.durationInSeconds != previous.durationInSeconds,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _getActionButtons(state, context),
        );
      },
    );
  }

  List<Widget> _getActionButtons(TimerState state, BuildContext context) {
    var separationDistanceForAnimation = 150.0;

    var neumorphicStyleTimerRunning = NeumorphicStyle(
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(13.0)),
      color: Colors.transparent,
      lightSource: LightSource.top,
      shape: NeumorphicShape.flat,
      intensity: 0.65,
    );

    var neumorphicStyleTimerStopped = NeumorphicStyle(
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(13.0)),
      color: Colors.white,
      lightSource: LightSource.top,
      shape: NeumorphicShape.convex,
    );

    return <Widget>[
      if (state is TimerInitial) ...[
        NeumorphicButton(
          onPressed: () => context
              .read<TimerBloc>()
              .add(TimerStarted(durationInSeconds: state.durationInSeconds)),
          style: neumorphicStyleTimerStopped,
          child: Icon(
            Icons.play_arrow,
          ),
        )
      ],
      if (state is TimerRunInProgress) ...[
        StackOpenAnimation(
          duration: const Duration(seconds: 1),
          separationDistance: separationDistanceForAnimation,
          leftWidget: NeumorphicButton(
            onPressed: () => context.read<TimerBloc>().add(TimerPaused()),
            style: neumorphicStyleTimerRunning,
            child: Icon(
              Icons.pause,
              color: Colors.white,
            ),
          ),
          rightWidget: NeumorphicButton(
            onPressed: () =>
                context.read<TimerBloc>().add(TimerRunningAndReset()),
            style: neumorphicStyleTimerRunning,
            child: Icon(
              Icons.replay,
              color: Colors.white,
            ),
          ),
        ),
      ],
      if (state is TimerRunPause) ...[
        StackOpenAnimation(
          duration: const Duration(seconds: 1),
          separationDistance: separationDistanceForAnimation,
          leftWidget: NeumorphicButton(
            onPressed: () => context.read<TimerBloc>().add(TimerResumed()),
            style: neumorphicStyleTimerStopped,
            child: Icon(Icons.play_arrow),
          ),
          rightWidget: NeumorphicButton(
            onPressed: () =>
                context.read<TimerBloc>().add(TimerPausedAndReset()),
            style: neumorphicStyleTimerStopped,
            child: Icon(Icons.replay),
          ),
        ),
      ],
      if (state is TimerRunComplete) ...[
        StackCloseAnimation(
          duration: const Duration(seconds: 1),
          separationDistance: separationDistanceForAnimation,
          leftWidget: NeumorphicButton(
            onPressed: () => Null,
            style: neumorphicStyleTimerStopped,
            child: const Icon(Icons.pause),
          ),
          rightWidget: NeumorphicButton(
            onPressed: () => context.read<TimerBloc>().add(TimerReset()),
            style: neumorphicStyleTimerStopped,
            child: const Icon(Icons.replay),
          ),
          leftWidgetIsOver: false,
        ),
      ],
      if (state is TimerInitialAfterPause) ...[
        StackCloseAnimation(
          duration: const Duration(seconds: 1),
          separationDistance: separationDistanceForAnimation,
          leftWidget: NeumorphicButton(
            onPressed: () => context
                .read<TimerBloc>()
                .add(TimerStarted(durationInSeconds: state.durationInSeconds)),
            style: neumorphicStyleTimerStopped,
            child: const Icon(Icons.play_arrow),
          ),
          rightWidget: NeumorphicButton(
            onPressed: () => Null,
            style: neumorphicStyleTimerStopped,
            child: const Icon(Icons.replay),
          ),
        ),
      ],
      if (state is TimerInitialWhileRunning) ...[
        StackCloseAnimation(
          duration: const Duration(seconds: 1),
          separationDistance: separationDistanceForAnimation,
          leftWidget: NeumorphicButton(
            onPressed: () => context
                .read<TimerBloc>()
                .add(TimerStarted(durationInSeconds: state.durationInSeconds)),
            style: neumorphicStyleTimerStopped,
            child: const Icon(Icons.play_arrow),
          ),
          rightWidget: NeumorphicButton(
            onPressed: () => Null,
            style: neumorphicStyleTimerStopped,
            child: const Icon(Icons.replay),
          ),
        ),
      ]
    ];
  }
}
