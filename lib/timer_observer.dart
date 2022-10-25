import 'package:flutter_bloc/flutter_bloc.dart';

class TimerObserver extends BlocObserver {
  TimerObserver();

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('${bloc.runtimeType} $transition');
  }
}
