import 'package:flutter_test/flutter_test.dart';
import 'package:ship_conquest/domain/game/minimap.dart';
import 'package:ship_conquest/domain/immutable_collections/grid.dart';
import 'package:ship_conquest/domain/path_builder/path_builder.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';

void main() {
  group('PathBuilder', () {
    test('should return an empty list when end position is out of bounds', () {
      // Arrange
      final map = Minimap(length: 10, data: Grid.empty());
      final start = Coord2D(x: 0, y: 0);
      final mid = Coord2D(x: 1, y: 1);
      final end = Coord2D(x: 10, y: 10);
      const step = 1;
      const radius = 1;
      const maxIterations = 100;

      // Act
      final result = PathBuilder.build(
        map,
        start,
        mid,
        end,
        step,
        radius,
        maxIterations,
      );

      // Assert
      expect(result, isEmpty);
    });

    test('should return an empty list when end position is not accessible', () {
      // Arrange

      final gridData = <Coord2D, int>{};
      // create a blocking barrier in the map, path can't end
      gridData.addAll(
          {
            Coord2D(x: 0, y: 9): 1,
            Coord2D(x: 1, y: 8): 1,
            Coord2D(x: 2, y: 7): 1,
            Coord2D(x: 3, y: 6): 1,
            Coord2D(x: 4, y: 5): 1,
            Coord2D(x: 5, y: 4): 1,
            Coord2D(x: 6, y: 3): 1,
            Coord2D(x: 7, y: 2): 1,
            Coord2D(x: 8, y: 1): 1,
            Coord2D(x: 9, y: 0): 1,
          }
      );

      final map = Minimap(length: 10, data: Grid(data: gridData));
      final start = Coord2D(x: 0, y: 0);
      final mid = Coord2D(x: 1, y: 1);
      final end = Coord2D(x: 9, y: 9);
      const step = 1;
      const radius = 1;
      const maxIterations = 100;

      // Act
      final result = PathBuilder.build(
        map,
        start,
        mid,
        end,
        step,
        radius,
        maxIterations,
      );

      // Assert
      expect(result, isEmpty);
    });

    test('should return the path when a valid path is found', () {
      // Arrange
      final map = Minimap(length: 10, data: Grid.empty());
      final start = Coord2D(x: 0, y: 0);
      final mid = Coord2D(x: 1, y: 1);
      final end = Coord2D(x: 5, y: 5);
      const step = 1;
      const radius = 1;
      const maxIterations = 100;

      // Act
      final result = PathBuilder.build(
        map,
        start,
        mid,
        end,
        step,
        radius,
        maxIterations,
      );

      // Assert
      expect(result, isNotEmpty);
    });

    test('should not include the midpoint in the path', () {
      // Arrange
      final map = Minimap(length: 10, data: Grid.empty());
      final start = Coord2D(x: 0, y: 0);
      final mid = Coord2D(x: 0, y: 9); // Midpoint in the center of the map
      final end = Coord2D(x: 9, y: 9);
      const step = 1;
      const radius = 1;
      const maxIterations = 100;

      final result = PathBuilder.build(
        map,
        start,
        mid,
        end,
        step,
        radius,
        maxIterations,
      );

      expect(result, isNotEmpty);
      expect(result.contains(mid), isFalse);
    });

    test('should normalize the path correctly', () {
      // Arrange
      final path = [
        Coord2D(x: 0, y: 0),
        Coord2D(x: 1, y: 1),
        Coord2D(x: 2, y: 2),
        Coord2D(x: 3, y: 3),
        Coord2D(x: 4, y: 4),
        Coord2D(x: 5, y: 5),
        Coord2D(x: 6, y: 6),
        Coord2D(x: 7, y: 7),
        Coord2D(x: 8, y: 8),
        Coord2D(x: 9, y: 9),
      ];
      const size = 4;

      // Act
      final result = PathBuilder.normalize(path, size);

      // Assert
      expect(result.length, size * 4);
      expect(result[0], path[0]);
      expect(result[size * 4 - 1], path[path.length - 1]);
    });

    test('should return an empty list when path is empty', () {
      // Arrange
      List<Coord2D> path = [];
      const size = 4;

      // Act
      final result = PathBuilder.normalize(path, size);

      // Assert
      expect(result, isEmpty);
    });
  });
}