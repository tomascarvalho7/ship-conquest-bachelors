import 'package:ship_conquest/domain/island/island.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';

class WildIsland implements Island {
  @override
  final int id;
  @override
  final Coord2D coordinate;
  @override
  final int radius;
  // constructor
  WildIsland({required this.id, required this.coordinate, required this.radius});
}