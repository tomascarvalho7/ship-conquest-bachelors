
import 'package:ship_conquest/domain/space/position.dart';
import 'package:ship_conquest/domain/stats/player_stats.dart';

import '../domain/color/color_gradient.dart';
import '../domain/game/game_data.dart';

/// Holds Application global state
///
/// Is responsible for handling the camera position and scale,
/// data of the current game and the statistics of the player.
class GlobalState {
  Position? _cameraPos;
  double? _cameraScale;
  GameData? _gameData;
  PlayerStats? _playerStats;
  // constructor
  GlobalState();
  // getters
  bool get isPlayable => _playerStats != null && _gameData != null;
  PlayerStats? get playerStats => _playerStats;
  GameData? get gameData  => _gameData;
  Position? get cameraPos => _cameraPos;
  double? get cameraScale => _cameraScale;

  /// Updates the players' statistics.
  void updatePlayerStats(PlayerStats playerStats) {
    _playerStats = playerStats;
  }

  /// Updates the games' data.
  void updateGameData(GameData? data) {
    _gameData = data;
  }

  /// Updates the camera's position and scale state.
  void updateCameraState(Position pos, double scale) {
    _cameraPos = pos;
    _cameraScale = scale;
  }
}