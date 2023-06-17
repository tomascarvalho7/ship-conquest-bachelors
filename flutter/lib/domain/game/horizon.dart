import 'package:ship_conquest/domain/island/island.dart';
import 'package:ship_conquest/domain/space/coordinate.dart';

/// Represents the horizon in game, that is the list of tiles and islands
/// close to the ship.
class Horizon {
  final List<Coordinate> tiles;
  final List<Island> islands;
  // constructor
  Horizon({required this.tiles, required this.islands});
}

