import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class SoundAndVibrationNotification {
  final AudioPlayer _player;
  bool _isVibrationActivated = true;

  SoundAndVibrationNotification({required AudioPlayer player})
      : _player = player {
    _player.setVolume(100.0);
  }

  void playEndTimerSound() {
    _player.setReleaseMode(ReleaseMode.stop);
    int fileNumber = Random().nextInt(5) + 1;
    _player.play(AssetSource('end_timer_bubble_sound_$fileNumber.wav'));
  }

  void playEndTimerVibration() async {
    if (_isVibrationActivated && (await Vibration.hasVibrator() ?? false)) {
      Vibration.vibrate();
    }
  }

  void disableSound() => _player.setVolume(0.0);
  void enableSound() => _player.setVolume(100.0);
  void disableVibration() => _isVibrationActivated = false;
  void enableVibration() => _isVibrationActivated = true;
}
