import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimatedWavyBackground extends StatelessWidget {
  const AnimatedWavyBackground({Key? key, required this.animation})
      : super(key: key);

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return ClipPath(
          clipper: MyWavyClipper(animation.value),
          child: child,
        );
      },
      child: const Background(),
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
