import '../space/coord_2d.dart';

/// Island Interface
abstract class Island {
  int get id;
  Coord2D get coordinate;
  int get radius;
}