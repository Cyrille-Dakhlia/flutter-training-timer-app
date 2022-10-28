import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer/components/animated_wavy_background.dart';
import 'package:flutter_timer/components/stack_animation.dart';
import 'package:flutter_timer/ticker.dart';
import 'package:flutter_timer/timer/bloc/timer_bloc.dart';
import 'package:vector_math/vector_math.dart' as vector;

class TimerPage extends StatelessWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerBloc(ticker: const Ticker()),
      child: TimerView(),
    );
  }
}

class TimerView extends StatefulWidget {
  TimerView({Key? key}) : super(key: key);

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  List<Offset> waveList = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      value: 0.0,
      upperBound: 1.0,
      lowerBound: 0.0,
      vsync: this,
    )
      ..repeat(reverse: true)
      ..addListener(() {
        waveList.clear();
        var size = MediaQuery.of(context).size;

        for (int i = 0; i <= size.width.toInt(); i++) {
          var offset = Offset(
              i.toDouble(),
              math.sin((_controller.value * 360 - i) %
                          360 *
                          vector.degrees2Radians) *
                      20 +
                  50);
          waveList.add(offset);
        }
      });

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Timer'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: [
          AnimatedWavyBackground(
            animation: _animation,
            waveList: waveList,
            startColor: Colors.indigo.shade100,
            endColor: Colors.indigo.shade900,
          ),
          AnimatedWavyBackground(
            animation: _animation,
            startColor: Colors.blue.shade50,
            endColor: Colors.blue.shade900,
          ),
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
