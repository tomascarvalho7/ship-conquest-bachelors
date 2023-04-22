
import 'package:ship_conquest/domain/space/position.dart';

import '../domain/color/color_gradient.dart';
import '../domain/game_data.dart';

/// holds Application global state
class GlobalState {
  final ColorGradient colorGradient;
  Position? _cameraPos;
  double? _cameraScale;
  GameData? _gameData;
  // constructor
  GlobalState({required this.colorGradient});
  // getters
  GameData? get gameData  => _gameData;
  Position? get cameraPos => _cameraPos;
  double? get cameraScale => _cameraScale;

  void updateGameData(GameData data) {
    _gameData = data;
  }

  void updateCameraState(Position pos, double scale) {
    _cameraPos = pos;
    _cameraScale = scale;
  }
}