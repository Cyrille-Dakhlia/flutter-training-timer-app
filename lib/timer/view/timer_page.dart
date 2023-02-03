import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_timer/components/animated_wavy_background.dart';
import 'package:flutter_timer/sound/sound_%20notification.dart';
import 'package:flutter_timer/ticker.dart';
import 'package:flutter_timer/timer/bloc/timer_bloc.dart';
import 'package:flutter_timer/timer/view/time_picker_page.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math.dart' as vector;

import 'components/action_buttons.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerBloc(ticker: const Ticker()),
      child: Provider(
        create: (_) => SoundNotification(player: AudioPlayer()),
        lazy: false,
        child: const TimerView(),
      ),
    );
  }
}

class TimerView extends StatefulWidget {
  const TimerView({Key? key}) : super(key: key);

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late AnimationController _controllerBottomSheet;
  late Animation<double> _animationBottomSheet;

  List<Offset> waveList = [];

  @override
  void initState() {
    super.initState();
    createBackgroundAnimations();
    createBottomSheetAnimation();
  }

  void createBackgroundAnimations() {
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

  void createBottomSheetAnimation() {
    _controllerBottomSheet = AnimationController(
      duration: const Duration(seconds: 12),
      value: 0.5,
      upperBound: 1.0,
      lowerBound: 0.0,
      vsync: this,
    )..repeat(reverse: true);

    _animationBottomSheet = CurvedAnimation(
        parent: _controllerBottomSheet, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerBottomSheet.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int initialDuration =
        context.select<TimerBloc, int>((_) => TimerBloc.initialDuration);

    var appBarItemsColor = Colors.indigo.withAlpha(80);

    return Scaffold(
      appBar: NeumorphicAppBar(
        title: NeumorphicText(
          'Soft Timer',
          style: NeumorphicStyle(
            color: appBarItemsColor,
          ),
          textStyle: NeumorphicTextStyle(
            fontSize: 25.0,
          ),
        ),
        centerTitle: true,
        leading: NeumorphicButton(
          onPressed: () => Null, //todo: should have settings to disable sound
          style: NeumorphicStyle(disableDepth: true),
          child: Icon(Icons.alarm_on, color: appBarItemsColor),
        ),
      ),
      body: BlocListener<TimerBloc, TimerState>(
        listener: (context, state) {
          if (state.runtimeType == TimerRunComplete) {
            context.read<SoundNotification>().playEndTimerSound();
          }
        },
        child: Stack(
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
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 50.0),
                  child: GestureDetector(
                    onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (_) => TimePickerPage(
                          context: context,
                          animationBottomSheet: _animationBottomSheet,
                          initialDurationInSeconds: initialDuration),
                      backgroundColor: Colors.transparent,
                      barrierColor: Colors.indigo.shade700.withAlpha(100),
                    ),
                    child: TimerText(),
                  ),
                ),
                ActionButtons(),
              ],
            ),
          ],
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
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w200,
            ),
      ),
    );
  }
}
