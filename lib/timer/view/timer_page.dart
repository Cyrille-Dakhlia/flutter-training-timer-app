import 'dart:math' as math;

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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      value: 0.0,
      upperBound: 1.0,
      lowerBound: 0.0,
      vsync: this,
    )..repeat(reverse: true);

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
          AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext context, Widget? child) {
              return ClipPath(
                clipper: MyWavyClipper(_animation.value),
                child: child,
              );
            },
            child: Background(),
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

class MyWavyClipper extends CustomClipper<Path> {
  double movingValue;
  MyWavyClipper(this.movingValue);

  @override
  Path getClip(Size size) {
    var marginFromTop = 50.0;

    var intensityFactorForControlPoints = 1.5;
    var intensityFactorForEdges = 0.3;

    var xVariation = size.width * math.cos(math.pi * movingValue);
    var yVariation =
        marginFromTop * math.sin(math.pi * movingValue - math.pi / 2);

    var xVariationForControlPoints =
        0.25 * xVariation * intensityFactorForControlPoints;
    var yVariationForControlPoints =
        2 * yVariation * intensityFactorForControlPoints;

    var x1ControlPoint = size.width * 0.25 + (xVariationForControlPoints);
    var y1ControlPoint = marginFromTop + (yVariationForControlPoints);

    var x2ControlPoint = size.width * 0.75 + (xVariationForControlPoints);
    var y2ControlPoint = marginFromTop * 2 - (yVariationForControlPoints);

    var yVariationForEdges = yVariation * intensityFactorForEdges;

    return Path()
      ..lineTo(0, marginFromTop + (yVariationForEdges))
      ..cubicTo(
        x1ControlPoint,
        y1ControlPoint,
        x2ControlPoint,
        y2ControlPoint,
        size.width,
        marginFromTop - (yVariationForEdges),
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<dynamic> oldClipper) => true;
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
