import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer/components/stack_animation.dart';
import 'package:flutter_timer/ticker.dart';
import 'package:flutter_timer/timer/bloc/timer_bloc.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerBloc(ticker: const Ticker()),
      child: const TimerView(),
    );
  }
}

class TimerView extends StatelessWidget {
  const TimerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Timer'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: [
          Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 50.0),
                child: TimerText(),
              ),
              ActionButtons(),
            ],
          ),
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.blue.shade900,
            ],
          ),
        ),
      ),
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minutesString =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsString = (duration % 60).toString().padLeft(2, '0');

    return Center(
      child: Text(
        '$minutesString:$secondsString',
        style: Theme.of(context).textTheme.headline1?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w200,
            ),
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _getActionButtons(state, context),
        );
      },
    );
  }

  List<Widget> _getActionButtons(TimerState state, BuildContext context) {
    return <Widget>[
      if (state is TimerInitial) ...[
        TextButton(
          onPressed: () => context.read<TimerBloc>().add(TimerStarted()),
          child: Icon(Icons.play_arrow),
        )
      ],
      if (state is TimerRunInProgress) ...[
        StackOpenAnimation(
          duration: const Duration(seconds: 1),
          separationDistance: 150.0,
          leftWidget: TextButton(
            onPressed: () => context.read<TimerBloc>().add(TimerPaused()),
            child: Icon(Icons.pause),
          ),
          rightWidget: TextButton(
            onPressed: () =>
                context.read<TimerBloc>().add(TimerRunningAndReset()),
            child: Icon(Icons.replay),
          ),
        ),
      ],
      if (state is TimerRunPause) ...[
        StackOpenAnimation(
          duration: const Duration(seconds: 1),
          separationDistance: 150.0,
          leftWidget: TextButton(
            onPressed: () => context.read<TimerBloc>().add(TimerResumed()),
            child: Icon(Icons.play_arrow),
          ),
          rightWidget: TextButton(
            onPressed: () =>
                context.read<TimerBloc>().add(TimerPausedAndReset()),
            child: Icon(Icons.replay),
          ),
        ),
      ],
      if (state is TimerRunComplete) ...[
        StackCloseAnimation(
          duration: const Duration(seconds: 1),
          separationDistance: 150.0,
          leftWidget: TextButton(
            onPressed: () => Null,
            child: const Icon(Icons.pause),
          ),
          rightWidget: TextButton(
            onPressed: () => context.read<TimerBloc>().add(TimerReset()),
            child: const Icon(Icons.replay),
          ),
          leftWidgetIsOver: false,
        ),
      ],
      if (state is TimerInitialAfterPause) ...[
        StackCloseAnimation(
          duration: const Duration(seconds: 1),
          separationDistance: 150.0,
          leftWidget: TextButton(
            onPressed: () => context.read<TimerBloc>().add(TimerStarted()),
            child: const Icon(Icons.play_arrow),
          ),
          rightWidget: TextButton(
            onPressed: () => Null,
            child: const Icon(Icons.replay),
          ),
        ),
      ],
      if (state is TimerInitialWhileRunning) ...[
        StackCloseAnimation(
          duration: const Duration(seconds: 1),
          separationDistance: 150.0,
          leftWidget: TextButton(
            onPressed: () => context.read<TimerBloc>().add(TimerStarted()),
            child: const Icon(Icons.play_arrow),
          ),
          rightWidget: TextButton(
            onPressed: () => Null,
            child: const Icon(Icons.replay),
          ),
        ),
      ]
    ];
  }
}
