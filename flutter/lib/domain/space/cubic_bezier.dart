
import 'dart:math';

import 'package:ship_conquest/domain/space/coord_2d.dart';
import 'package:ship_conquest/domain/space/position.dart';

/// Represents a cubic Bézier curve by its start and end points
/// as well as its 2 anchor points
class CubicBezier {
  final Coord2D p0;
  final Coord2D p1;
  final Coord2D p2;
  final Coord2D p3;
  // constructor
  CubicBezier({required this.p0, required this.p1, required this.p2, required this.p3});

  /// Retrieve the current position in the Bézier curve according to an interpolation value [n].
  Position get(double n) {
    double _n = 1.0 - n;
    double _n2 = _n * _n;
    double _n3 = _n2 * _n;
    double n2 = n * n;
    double n3 = n2 * n;
    // formula:
    // P(t) = (1 - t)^3 * P1 + 3 * (1 - t)^2 * t * P2 + 3 * (1 - t) * t^2 * P3 + t^3 * P4
    return Position(
        x: _n3 * p0.x + 3 * _n2 * n * p1.x + 3 * _n * n2 * p2.x + n3 * p3.x,
        y: _n3 * p0.y + 3 * _n2 * n * p1.y + 3 * _n * n2 * p2.y + n3 * p3.y
    );
  }

  /// Retrieves the angle of the curve according to an interpolation value [n].
  double getAngleAtPoint(double n) {
    Position tangent = getTangentAtPoint(n);
    double angle = atan2(tangent.y, tangent.x);
    // convert negative angle to positive equivalent
    if (angle < 0) angle += 2 * pi;
    return angle * 180 / pi; // convert to degrees
  }

  /// Retrieves the tangent at a point of the curve according to an interpolation value [n].
  Position getTangentAtPoint(double n) {
    Position dp0 = (p1 - p0) * 3.0;
    Position dp1 = (p2 - p1) * 3.0;
    Position dp2 = (p3 - p2) * 3.0;

    double _n = 1.0 - n;
    double _n2 = _n * _n;
    double n2 = n * n;
    // get tangent
    Position tangent = dp0 * _n2 + dp1 * (2 * _n * n) + dp2 * n2;
    // normalize
    double length = sqrt(tangent.x * tangent.x + tangent.y * tangent.y);
    return Position(x: tangent.x / length, y: tangent.y / length);
  }
}