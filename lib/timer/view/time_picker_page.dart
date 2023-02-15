import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../components/animated_wavy_background.dart';
import '../bloc/timer_bloc.dart';

Duration _selectedDuration = Duration.zero;

class TimePickerPage extends StatelessWidget {
  const TimePickerPage({
    Key? key,
    required context,
    required this.animationBottomSheet,
    this.initialDurationInSeconds = 0,
  })  : _context = context,
        super(key: key);

  final BuildContext _context;
  final Animation<double> animationBottomSheet;
  final int initialDurationInSeconds;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedWavyBackground(
            animation: animationBottomSheet,
            startColor: Colors.black12,
            endColor: Colors.black38),
        Padding(
          padding: const EdgeInsets.only(top: 1.0),
          child: AnimatedWavyBackground(
              animation: animationBottomSheet,
              startColor: Colors.blue.shade100,
              endColor: Colors.indigo.shade700),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 35.0, bottom: 25.0),
              child:
                  CustomTimePicker(initialDuration: initialDurationInSeconds),
            ),
            NeumorphicButton(
              onPressed: () {
                _context.read<TimerBloc>().add(TimerChanged(
                    newDurationInSeconds: _selectedDuration.inSeconds));
                Navigator.pop(context);
              },
              style: NeumorphicStyle(
                  color: Colors.indigo,
                  depth: 2.5,
                  lightSource: LightSource.top,
                  shape: NeumorphicShape.convex),
              child: Text(
                'Reset Timer',
                style: TextStyle(
                  color: CupertinoColors.extraLightBackgroundGray,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomTimePicker extends StatelessWidget {
  const CustomTimePicker({Key? key, this.initialDuration = 0})
      : super(key: key);

  final int initialDuration;

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);
    final pickerTextStyle = cupertinoTheme.textTheme.pickerTextStyle
        .copyWith(color: CupertinoColors.extraLightBackgroundGray);
    final textTheme =
        cupertinoTheme.textTheme.copyWith(pickerTextStyle: pickerTextStyle);

    return CupertinoTheme(
      data: cupertinoTheme.copyWith(textTheme: textTheme),
      child: CupertinoTimerPicker(
        initialTimerDuration: Duration(seconds: initialDuration),
        onTimerDurationChanged: (duration) => _selectedDuration = duration,
        mode: CupertinoTimerPickerMode.ms,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
