import 'package:ship_conquest/domain/minimap.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/domain/space/sequence.dart';
import 'package:ship_conquest/domain/stats/player_stats.dart';

class GameData {
  final Minimap minimap;
  final Sequence<Ship> ships;
  // constructor
  GameData({required this.minimap, required this.ships});
}