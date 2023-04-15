import 'package:ship_conquest/domain/ship/ship.dart';

import '../space/position.dart';
import 'direction.dart';

class StaticShip extends Ship {
  final Position position;
  final Direction orientation;
  // constructor
  StaticShip({required this.position, required this.orientation});

  @override
  Position getPosition(double scale) => position * scale;

  @override
  Direction getOrientation() => orientation;
}