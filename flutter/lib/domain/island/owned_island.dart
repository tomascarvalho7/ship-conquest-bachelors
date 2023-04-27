import '../space/coord_2d.dart';
import 'island.dart';

class OwnedIsland implements Island {
  @override
  final int id;
  @override
  final Coord2D coordinate;
  @override
  final int radius;
  final int incomePerHour;
  final String uid;
  // constructor
  OwnedIsland({required this.id, required this.coordinate, required this.radius, required this.incomePerHour, required this.uid});
}