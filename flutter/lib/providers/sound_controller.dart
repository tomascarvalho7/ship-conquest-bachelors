import 'package:audioplayers/audioplayers.dart';

///
/// Independent global controller that holds a [State]
/// to manage and play audio inside the application.
///
class SoundController {
  final _background = AudioPlayer()
    ..setPlayerMode(PlayerMode.mediaPlayer)
    ..setReleaseMode(ReleaseMode.loop);
  final _player = AudioPlayer()
    ..setPlayerMode(PlayerMode.lowLatency);

  void startBackgroundMusic() {
    _background.play(AssetSource('sounds/dreamland.mp3'), volume: .5);
  }

  void playNotificationSound() {
    _player.play(AssetSource('sounds/notification.wav'));
  }

  void pauseAudio() {
    _player.pause();
    _background.pause();
  }

  void resumeAudio() {
    _player.resume();
    _background.resume();
  }

  void stopAudio() {
    _background.stop();
    _player.stop();
  }

  void dispose() {
    _background.dispose();
    _player.dispose();
  }
}