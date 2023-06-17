import 'package:flutter_test/flutter_test.dart';
import 'package:ship_conquest/domain/event/known_event.dart';
import 'package:ship_conquest/domain/immutable_collections/grid.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/domain/ship/utils/classes/direction.dart';
import 'package:ship_conquest/domain/ship/utils/classes/ship_path.dart';
import 'package:ship_conquest/domain/ship/utils/logic.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';
import 'package:ship_conquest/domain/space/cubic_bezier.dart';
import 'package:ship_conquest/domain/space/position.dart';

void main() {
  group('Getting angles', () {
    test('should retrieve the correct ship orientation from an angle', () {
      const angle1 = 45.0; // Angle for Direction.right
      const angle2 = 135.0; // Angle for Direction.down
      const angle3 = 225.0; // Angle for Direction.left
      const angle4 = 315.0; // Angle for Direction.up

      final orientation1 = getOrientationFromAngle(angle1);
      final orientation2 = getOrientationFromAngle(angle2);
      final orientation3 = getOrientationFromAngle(angle3);
      final orientation4 = getOrientationFromAngle(angle4);

      expect(orientation1, Direction.right);
      expect(orientation2, Direction.down);
      expect(orientation3, Direction.left);
      expect(orientation4, Direction.up);
    });
  });

  group('ShipPath', () {
    test('should retrieve the correct ship position based on time', () {
      // Arrange
      final now = DateTime.now(); // Set the current time
      final startTime = now.subtract(const Duration(minutes: 30)); // 30 minutes ago
      const duration = Duration(minutes: 60); // 1 hour
      final landmarks = [
        CubicBezier(p0: Coord2D(x: 0, y: 0), p1: Coord2D(x: 50, y: 100), p2: Coord2D(x: 100, y: 0), p3: Coord2D(x: 150, y: 100)),
        CubicBezier(p0: Coord2D(x: 150, y: 100), p1: Coord2D(x: 200, y: 0), p2: Coord2D(x: 250, y: 100), p3: Coord2D(x: 300, y: 0)),
      ];
      final shipPath = ShipPath(landmarks: landmarks, startTime: startTime, duration: duration);

      // Act
      final position = shipPath.getPositionFromTime();

      // Assert
      expect(position, const Position(x: 150, y: 100));
    });

    test('should retrieve the correct ship angle based on time', () {
      // Arrange
      final now = DateTime.now(); // Set the current time
      final startTime = now.subtract(const Duration(minutes: 30)); // 30 minutes ago
      const duration = Duration(minutes: 60); // 1 hour
      final landmarks = [
        CubicBezier(p0: Coord2D(x: 0, y: 0), p1: Coord2D(x: 50, y: 100), p2: Coord2D(x: 100, y: 150), p3: Coord2D(x: 200, y: 250)),
        CubicBezier(p0: Coord2D(x: 200, y: 250), p1: Coord2D(x: 300, y: 350), p2: Coord2D(x: 400, y: 450), p3: Coord2D(x: 500, y: 550)),
      ];
      final shipPath = ShipPath(landmarks: landmarks, startTime: startTime, duration: duration);

      // Act
      final angle = shipPath.getAngleFromTime();

      // Assert
      expect(angle, closeTo(40, 50));
    });

    test('should indicate that the ship has reached its destination', () {
      // Arrange
      final now = DateTime(2023, 6, 1, 14, 0, 0); // Set the current time
      final startTime = now.subtract(const Duration(minutes: 30)); // 30 minutes ago
      const duration = Duration(minutes: 60); // 1 hour
      final landmarks = [
        CubicBezier(p0: Coord2D(x: 0, y: 0), p1: Coord2D(x: 50, y: 100), p2: Coord2D(x: 100, y: 0), p3: Coord2D(x: 150, y: 100)),
        CubicBezier(p0: Coord2D(x: 150, y: 100), p1: Coord2D(x: 200, y: 0), p2: Coord2D(x: 250, y: 100), p3: Coord2D(x: 300, y: 0)),
      ];
      final shipPath = ShipPath(landmarks: landmarks, startTime: startTime, duration: duration);

      // Act
      final hasReachedDestiny = shipPath.hasReachedDestiny();

      // Assert
      expect(hasReachedDestiny, isTrue);
    });
  });

  group('Ship Fighting Logic', () {
    test('should return true if ship is currently fighting', () {
      final landmarks = [
        CubicBezier(p0: Coord2D(x: 0, y: 0), p1: Coord2D(x: 50, y: 100), p2: Coord2D(x: 100, y: 0), p3: Coord2D(x: 150, y: 100)),
        CubicBezier(p0: Coord2D(x: 150, y: 100), p1: Coord2D(x: 200, y: 0), p2: Coord2D(x: 250, y: 100), p3: Coord2D(x: 300, y: 0)),
      ];
      Grid<int, KnownEvent> completedEvents = Grid<int, KnownEvent>.empty();
      completedEvents = completedEvents.put(0, FightEvent(eid: 0, instant: DateTime.now(), won: true));
      // Arrange
      final ship = MobileShip(
        sid: 0,
        path: ShipPath(
            landmarks: landmarks,
            startTime: DateTime.now().subtract(const Duration(minutes: 2)),
            duration: const Duration(minutes: 5)
        ),
        completedEvents: completedEvents,
        futureEvents: Grid.empty(),
      );
      final instant = DateTime.now().add(const Duration(seconds: 20));

      // Act
      final isFighting = ship.isFighting(instant);

      // Assert
      expect(isFighting, true);
    });

    test('should return false if ship is not currently fighting', () {
      final landmarks = [
        CubicBezier(p0: Coord2D(x: 0, y: 0), p1: Coord2D(x: 50, y: 100), p2: Coord2D(x: 100, y: 0), p3: Coord2D(x: 150, y: 100)),
        CubicBezier(p0: Coord2D(x: 150, y: 100), p1: Coord2D(x: 200, y: 0), p2: Coord2D(x: 250, y: 100), p3: Coord2D(x: 300, y: 0)),
      ];
      Grid<int, KnownEvent> completedEvents = Grid<int, KnownEvent>.empty();
      completedEvents = completedEvents.put(0, FightEvent(eid: 0, instant: DateTime.now(), won: true));
      // Arrange
      final ship = MobileShip(
        sid: 0,
        path: ShipPath(landmarks: landmarks, startTime: DateTime.now(), duration: const Duration(minutes: 1)),
        completedEvents: completedEvents,
        futureEvents: Grid.empty(),
      );
      final instant = DateTime.now().add(const Duration(minutes: 2)); // 14:00:00

      // Act
      final isFighting = ship.isFighting(instant);

      // Assert
      expect(isFighting, false);
    });
  });
}
