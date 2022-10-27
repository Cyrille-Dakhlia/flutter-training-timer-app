import 'package:flutter/material.dart';

class StackOpenAnimation extends StatelessWidget {
  Duration duration;
  double separationDistance;
  Widget leftWidget, rightWidget;
  bool leftWidgetIsOver;

  StackOpenAnimation(
      {Key? key,
      required this.duration,
      required this.separationDistance,
      required this.leftWidget,
      required this.rightWidget,
      this.leftWidgetIsOver = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StackAnimation(
      duration: duration,
      begin: 0.0,
      end: separationDistance,
      leftWidget: leftWidget,
      rightWidget: rightWidget,
      leftWidgetIsOver: leftWidgetIsOver,
    );
  }
}

class StackCloseAnimation extends StatelessWidget {
  Duration duration;
  double separationDistance;
  Widget leftWidget, rightWidget;
  bool leftWidgetIsOver;

  StackCloseAnimation(
      {Key? key,
      required this.duration,
      required this.separationDistance,
      required this.leftWidget,
      required this.rightWidget,
      this.leftWidgetIsOver = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StackAnimation(
      duration: duration,
      begin: separationDistance,
      end: 0.0,
      leftWidget: leftWidget,
      rightWidget: rightWidget,
      leftWidgetIsOver: leftWidgetIsOver,
    );
  }
}

class StackAnimation extends StatelessWidget {
  Duration duration;
  double begin, end;
  Widget leftWidget, rightWidget;
  bool leftWidgetIsOver;
  StackAnimation(
      {Key? key,
      required this.duration,
      required this.begin,
      required this.end,
      required this.leftWidget,
      required this.rightWidget,
      this.leftWidgetIsOver = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween<double>(begin: begin, end: end),
      curve: Curves.easeInOut,
      builder: (_, value, __) => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          if (leftWidgetIsOver) ...[
            Padding(
              padding: EdgeInsets.only(left: value),
              child: rightWidget,
            ),
            Padding(
              padding: EdgeInsets.only(right: value),
              child: leftWidget,
            ),
          ] else ...[
            Padding(
              padding: EdgeInsets.only(right: value),
              child: leftWidget,
            ),
            Padding(
              padding: EdgeInsets.only(left: value),
              child: rightWidget,
            ),
          ]
        ],
      ),
    );
  }
}
