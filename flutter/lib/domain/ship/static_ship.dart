import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';

import '../space/position.dart';
import 'direction.dart';

class StaticShip extends Ship {
  final int sid;
  final Coord2D coordinate;
  // constructor
  StaticShip({required this.sid, required this.coordinate});

  static const direction = Direction.up;

  @override
  int getSid() => sid;

  @override
  Position getPosition(double scale) => coordinate * scale;

  @override
  Direction getDirection() => direction;
}