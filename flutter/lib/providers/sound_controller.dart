import 'package:audioplayers/audioplayers.dart';

///
/// Independent global controller that holds a [State]
/// to manage and play audio inside the application.
///
class SoundController {
  final _background = AudioPlayer()..setReleaseMode(ReleaseMode.loop);
  final _player = AudioPlayer();

  void startBackgroundMusic() {
    _background.play(AssetSource('sounds/dreamland.wav'));
  }

  void stopBackgroundMusic() {
    _background.stop();
  }

  void playNotificationSound() {
    _player.play(AssetSource('sounds/notification.wav'));
  }
}