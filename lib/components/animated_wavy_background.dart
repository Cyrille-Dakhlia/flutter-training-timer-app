import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimatedWavyBackground extends StatelessWidget {
  AnimatedWavyBackground(
      {Key? key,
      required this.animation,
      this.waveList,
      required this.startColor,
      required this.endColor})
      : super(key: key);

  final Animation<double> animation;
  final Color startColor;
  final Color endColor;

  // Use List<Offset>? waveList parameter only if you want to define a background with your own shape
  List<Offset>? waveList;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ClipPath(
          clipper: (waveList == null)
              ? MyWavyClipper(animation.value)
              : CustomClipperFromOffsetList(animation.value, waveList!),
          child: child,
        );
      },
      child: GradientBackground(
        startColor: startColor,
        endColor: endColor,
      ),
    );
  }
}

class CustomClipperFromOffsetList extends CustomClipper<Path> {
  final double animation;
  List<Offset> waveList = [];

  CustomClipperFromOffsetList(this.animation, this.waveList);

  @override
  Path getClip(Size size) {
    return Path()
      ..addPolygon(waveList, false)
      ..lineTo(size.width, size.height)
      ..lineTo(0.0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipperFromOffsetList oldClipper) =>
      animation != oldClipper.animation;
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

class GradientBackground extends StatelessWidget {
  const GradientBackground(
      {Key? key, required this.startColor, required this.endColor})
      : super(key: key);

  final Color startColor;
  final Color endColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [startColor, endColor],
          ),
        ),
      ),
    );
  }
}
