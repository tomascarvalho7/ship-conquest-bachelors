import 'package:flutter_test/flutter_test.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';
import 'package:ship_conquest/domain/space/cubic_bezier.dart';
import 'package:ship_conquest/domain/space/position.dart';
import 'package:ship_conquest/domain/utils/build_bezier.dart';

void main() {
  group('CubicBezier', () {
    test('should retrieve the correct position on the curve', () {
      // Arrange
      final p0 = Coord2D(x: 0, y: 0);
      final p1 = Coord2D(x: 50, y: 100);
      final p2 = Coord2D(x: 100, y: 0);
      final p3 = Coord2D(x: 150, y: 100);
      final bezier = CubicBezier(p0: p0, p1: p1, p2: p2, p3: p3);
      const n = 0.5; // Interpolation value

      // Act
      final position = bezier.get(n);

      // Assert
      expect(position, const Position(x: 75, y: 50));
    });

    test('should retrieve the correct angle at the starting point of the curve',
        () {
      // Arrange
      final p0 = Coord2D(x: 0, y: 0);
      final p1 = Coord2D(x: 50, y: 100);
      final p2 = Coord2D(x: 100, y: 0);
      final p3 = Coord2D(x: 150, y: 100);
      final bezier = CubicBezier(p0: p0, p1: p1, p2: p2, p3: p3);

      // Act
      final angle = bezier.getAngleAtPoint(0.0);

      // Assert
      expect(angle, closeTo(63.0, 0.5));
    });

    test('should build cubic Bézier curves from a list of points', () {
      // Arrange
      final points = [
        Coord2D(x: 0, y: 0),
        Coord2D(x: 50, y: 100),
        Coord2D(x: 100, y: 0),
        Coord2D(x: 150, y: 100),
        Coord2D(x: 200, y: 0),
        Coord2D(x: 250, y: 100),
        Coord2D(x: 300, y: 0),
        Coord2D(x: 350, y: 100),
      ];

      // Act
      final beziers = buildBeziers(points);

      // Assert
      expect(beziers.length, 2);
      expect(beziers[0].p0, Coord2D(x: 0, y: 0));
      expect(beziers[0].p1, Coord2D(x: 50, y: 100));
      expect(beziers[0].p2, Coord2D(x: 100, y: 0));
      expect(beziers[0].p3, Coord2D(x: 150, y: 100));
      expect(beziers[1].p0, Coord2D(x: 200, y: 0));
      expect(beziers[1].p1, Coord2D(x: 250, y: 100));
      expect(beziers[1].p2, Coord2D(x: 300, y: 0));
      expect(beziers[1].p3, Coord2D(x: 350, y: 100));
    });

    test('should return empty list by when receiving an empty list of points', () {
      // Arrange
      final List<Coord2D> points = [];

      // Act
      final beziers = buildBeziers(points);

      // Assert
      expect(beziers.length, 0);
    });
  });
}
