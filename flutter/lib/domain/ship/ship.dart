import 'package:ship_conquest/domain/immutable_collections/grid.dart';
import 'package:ship_conquest/domain/ship/ship_path.dart';
import 'package:ship_conquest/domain/space/position.dart';

import '../event/known_event.dart';
import '../event/unknown_event.dart';
import '../space/coord_2d.dart';
import 'direction.dart';

sealed class Ship {
  int get sid;
  Position getPosition(double scale);
  Direction getDirection();
  Grid<int, KnownEvent> get completedEvents;
  Grid<int, UnknownEvent> get futureEvents;
}

class MobileShip extends Ship {
  @override
  final int sid;
  final ShipPath path;
  @override
  final Grid<int, KnownEvent> completedEvents;
  @override
  final Grid<int, UnknownEvent> futureEvents;
  // constructor
  MobileShip({required this.sid, required this.path, required this.completedEvents, required this.futureEvents});

  @override
  Position getPosition(double scale) => path.getPositionFromTime() * scale;

  @override
  Direction getDirection() => getOrientationFromAngle(path.getAngleFromTime());
}

class StaticShip extends Ship {
  @override
  final int sid;
  final Coord2D coordinate;
  @override
  final Grid<int, KnownEvent> completedEvents;
  @override
  final Grid<int, UnknownEvent> futureEvents;

  // constructor
  StaticShip({required this.sid, required this.coordinate, required this.completedEvents, required this.futureEvents});

  @override
  Position getPosition(double scale) => coordinate * scale;

  @override
  Direction getDirection() => Direction.up;
}