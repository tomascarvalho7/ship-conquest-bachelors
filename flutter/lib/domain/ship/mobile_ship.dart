import 'package:ship_conquest/domain/ship/direction.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/domain/ship/ship_path.dart';
import 'package:ship_conquest/domain/space/position.dart';

import '../event/known_event.dart';
import '../event/unknown_event.dart';
import '../immutable_collections/sequence.dart';

class MobileShip extends Ship {
  final int sid;
  final ShipPath path;
  final Sequence<KnownEvent> completedEvents;
  final Sequence<UnknownEvent> futureEvents;
  // constructor
  MobileShip({required this.sid, required this.path, required this.completedEvents, required this.futureEvents});

  @override
  int getSid() => sid;

  @override
  Position getPosition(double scale) => path.getPositionFromTime() * scale;

  @override
  Direction getDirection() => getOrientationFromAngle(path.getAngleFromTime());

  Direction getOrientationFromAngle(double ang) {
    final angle = ang + 45;
    if (angle > 0 && angle <= 90) return Direction.right;
    if (angle > 90 && angle <= 180) return Direction.down;
    if (angle > 180 && angle <= 270) return Direction.left;
    return Direction.up;
  }
}