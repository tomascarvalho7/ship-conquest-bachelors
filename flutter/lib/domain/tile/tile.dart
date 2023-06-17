import 'package:ship_conquest/domain/space/coord_2d.dart';

/// Represents a game tile by its [coordinate] and [height].
class Tile {
  final Coord2D coordinate;
  final double height;
  // constructor
  Tile({required this.coordinate, required this.height});
}