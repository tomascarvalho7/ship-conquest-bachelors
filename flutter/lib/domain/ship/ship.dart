import 'package:ship_conquest/domain/event/known_event.dart';
import 'package:ship_conquest/domain/event/unknown_event.dart';
import 'package:ship_conquest/domain/immutable_collections/grid.dart';
import 'package:ship_conquest/domain/ship/utils/classes/direction.dart';
import 'package:ship_conquest/domain/ship/utils/classes/ship_path.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';
import 'package:ship_conquest/domain/space/position.dart';

/// Sealed class [Ship] contains the main properties of a ship,
/// other classes inside the same library can implement it.
sealed class Ship {
  int get sid;
  /// Retrieve the current position of the ship.
  Position getPosition(double scale);
  /// Retrieve the current direction of the ship.
  Direction getDirection();
  Grid<int, KnownEvent> get completedEvents;
  Grid<int, UnknownEvent> get futureEvents;
}

/// Represents a mobile ship by adding a [path] property.
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

/// Represents a mobile ship by adding a [coordinate] property.
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
  Direction getDirection() => Direction.northEast;
}