import 'package:ship_conquest/domain/utils/distance.dart';

import '../space/coord_2d.dart';
import '../space/position.dart';

/// Island Interface
abstract class Island {
  int get id;
  Coord2D get coordinate;
  int get radius;
}

extension Utils on Island {
  bool isCloseTo(Position position) =>
    distance(coordinate.toPosition(), position) <= radius * 1.5;
}