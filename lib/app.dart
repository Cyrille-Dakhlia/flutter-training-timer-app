import 'package:flutter/material.dart';
import 'package:flutter_timer/timer/view/timer_page.dart';

class TimerApp extends StatelessWidget {
  const TimerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Timer',
      theme: ThemeData(
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: const Color.fromRGBO(72, 74, 126, 1),
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            elevation: 3.0,
            fixedSize: const Size(50.0, 50.0),
          ),
        ),
        primaryColor: const Color.fromRGBO(109, 234, 255, 1),
        colorScheme: const ColorScheme.light(
          secondary: Color.fromRGBO(72, 74, 126, 1),
        ),
      ),
      home: const TimerPage(),
    );
  }
}
