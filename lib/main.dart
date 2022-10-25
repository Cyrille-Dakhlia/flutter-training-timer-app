import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer/timer_observer.dart';

import 'app.dart';

void main() {
  Bloc.observer = TimerObserver();
  runApp(const TimerApp());
}
