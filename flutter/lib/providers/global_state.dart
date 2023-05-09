
import 'package:ship_conquest/domain/space/position.dart';
import 'package:ship_conquest/domain/stats/player_stats.dart';

import '../domain/color/color_gradient.dart';
import '../domain/game_data.dart';

/// holds Application global state
class GlobalState {
  final ColorGradient colorGradient;
  Position? _cameraPos;
  double? _cameraScale;
  GameData? _gameData;
  PlayerStats? _playerStats;
  // constructor
  GlobalState({required this.colorGradient});
  // getters
  bool get isPlayable => _playerStats != null && _gameData != null;
  PlayerStats? get playerStats => _playerStats;
  GameData? get gameData  => _gameData;
  Position? get cameraPos => _cameraPos;
  double? get cameraScale => _cameraScale;

  void updatePlayerStats(PlayerStats playerStats) {
    _playerStats = playerStats;
  }

  void updateGameData(GameData? data) {
    _gameData = data;
  }

  void updateCameraState(Position pos, double scale) {
    _cameraPos = pos;
    _cameraScale = scale;
  }
}