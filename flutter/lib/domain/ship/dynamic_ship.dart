import 'package:ship_conquest/domain/ship/direction.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/domain/ship/ship_path.dart';
import 'package:ship_conquest/domain/space/position.dart';

class DynamicShip extends Ship {
  final ShipPath path;
  // constructor
  DynamicShip({required this.path});

  @override
  Position getPosition(double scale) => path.getPositionFromTime() * scale;

  @override
  Direction getOrientation() => getOrientationFromAngle(path.getAngleFromTime());

  Direction getOrientationFromAngle(double angle) {
    if (angle > 90 && angle <= 180) return Direction.up;
    if (angle > 180 && angle <= 270) return Direction.left;
    if (angle > 270 && angle <= 0) return Direction.down;
    return Direction.right;
  }
}