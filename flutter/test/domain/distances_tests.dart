import 'package:flutter_test/flutter_test.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';
import 'package:ship_conquest/domain/space/position.dart';
import 'package:ship_conquest/domain/utils/distance.dart';

void main() {
  group('Distances', () {
    test('should calculate the Euclidean distance between two positions', () {
      // Arrange
      const start = Position(x: 0, y: 0);
      const end = Position(x: 3, y: 4);

      // Act
      final result = distance(start, end);

      // Assert
      expect(result, closeTo(5.0, 0.001));
    });

    test('should calculate the Euclidean distance between two 2D coordinates', () {
      // Arrange
      final start = Coord2D(x: 0, y: 0);
      final end = Coord2D(x: 3, y: 4);

      // Act
      final result = euclideanDistance(start, end);

      // Assert
      expect(result, closeTo(5.0, 0.001));
    });

    test('should calculate the Manhattan distance between two 2D coordinates', () {
      // Arrange
      final start = Coord2D(x: 0, y: 0);
      final end = Coord2D(x: 3, y: 4);

      // Act
      final result = manhattanDistance(start, end);

      // Assert
      expect(result, 7.0);
    });

  });
}