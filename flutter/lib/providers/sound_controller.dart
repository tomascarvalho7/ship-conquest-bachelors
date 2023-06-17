import 'package:audioplayers/audioplayers.dart';

///
/// Independent global controller that holds a [State]
/// to manage and play audio inside the application.
///
class SoundController {
  /// Sets the background sound player and release mode.
  /// PlayerMode.mediaPlayer is usually used for larger files.
  /// ReleaseMode.loop makes it so that the background music continues looping after ending.
  final _background = AudioPlayer()
    ..setPlayerMode(PlayerMode.mediaPlayer)
    ..setReleaseMode(ReleaseMode.loop);

  /// Sets a default audio player to be used for notifications.
  final _player = AudioPlayer();

  /// Starts the background music by indicating the file source and the sound's volume.
  void startBackgroundMusic() {
    _background.play(AssetSource('sounds/dreamland.mp3'), volume: .5);
  }

  /// Plays the notification sound.
  void playNotificationSound() {
    _player.play(AssetSource('sounds/notification.wav'));
  }

  /// Pauses all the audios, saving the pausing point.
  void pauseAudio() {
    _player.pause();
    _background.pause();
  }

  /// Resumes all the paused audios from the pausing point.
  void resumeAudio() {
    _player.resume();
    _background.resume();
  }

  /// Stops all the audios playing, not saving the stopping point.
  void stopAudio() {
    _background.stop();
    _player.stop();
  }

  /// Disposes the audio players, the players can't be used after being disposed.
  void dispose() {
    _background.dispose();
    _player.dispose();
  }
}