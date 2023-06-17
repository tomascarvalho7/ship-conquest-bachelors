import 'package:ship_conquest/domain/game/minimap.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';

/// Holds the data of the game, namely its [minimap] and the list of [ships].
class GameData {
  final Minimap minimap;
  final Sequence<Ship> ships;
  // constructor
  GameData({required this.minimap, required this.ships});
}