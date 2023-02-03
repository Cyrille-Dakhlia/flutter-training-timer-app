import 'dart:math';

import 'package:audioplayers/audioplayers.dart';

class SoundNotification {
  final AudioPlayer _player;

  SoundNotification({required AudioPlayer player}) : _player = player {
    _player.setVolume(100.0);
  }

  void playEndTimerSound() {
    _player.setReleaseMode(ReleaseMode.stop);
    int fileNumber = Random().nextInt(5) + 1;
    _player.play(AssetSource('end_timer_bubble_sound_$fileNumber.wav'));
  }

  void disableSound() => _player.setVolume(0.0);
  void enableSound() => _player.setVolume(100.0);
}
