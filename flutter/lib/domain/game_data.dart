import 'package:ship_conquest/domain/minimap.dart';
import 'package:ship_conquest/domain/ship/ship.dart';

class GameData {
  final Minimap minimap;
  final List<Ship> ships;
  // constructor
  GameData({required this.minimap, required this.ships});
}