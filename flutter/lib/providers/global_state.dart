
import '../domain/color/color_gradient.dart';
import '../domain/game_data.dart';

/// holds Application global state
class GlobalState {
  final ColorGradient colorGradient;
  GameData? _gameData;
  // constructor
  GlobalState({required this.colorGradient});
  // getters
  GameData? get gameData  => _gameData;

  void updateGameData(GameData data) {
    _gameData = data;
  }
}