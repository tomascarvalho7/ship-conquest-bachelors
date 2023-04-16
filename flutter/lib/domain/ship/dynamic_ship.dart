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

  Direction getOrientationFromAngle(double ang) {
    final angle = ang + 45;
    if (angle > 0 && angle <= 90) return Direction.right;
    if (angle > 90 && angle <= 180) return Direction.down;
    if (angle > 180 && angle <= 270) return Direction.left;
    return Direction.up;
  }
}