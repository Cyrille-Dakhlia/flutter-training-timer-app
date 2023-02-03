import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_timer/timer/view/timer_page.dart';

class TimerApp extends StatelessWidget {
  const TimerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return NeumorphicApp(
      themeMode: ThemeMode.light,
      title: 'Soft Timer',
      theme: NeumorphicThemeData(
        baseColor: Colors.white,
      ),
      home: const TimerPage(),
    );
  }
}
