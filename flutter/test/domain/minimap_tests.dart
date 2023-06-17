import 'package:flutter_test/flutter_test.dart';
import 'package:ship_conquest/domain/game/minimap.dart';
import 'package:ship_conquest/domain/immutable_collections/grid.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';

void main() {
  group('Minimap group', () {
    test('should add and retrieve data correctly', () {
      final map = Minimap(length: 10, data: Grid<Coord2D, int>.empty());
      final expectedData = {
        Coord2D(x: 1, y: 1): 5,
        Coord2D(x: 3, y: 2): 10,
        Coord2D(x: 5, y: 5): 3,
      };

      map.add(x: 1, y: 1, height: 5);
      map.add(x: 3, y: 2, height: 10);
      map.add(x: 5, y: 5, height: 3);

      expect(map.data.data, expectedData);
    });

    test('should retrieve null for invalid coordinates', () {
      final map = Minimap(length: 10, data: Grid<Coord2D, int>.empty());

      final result = map.get(x: 1, y: 1);

      expect(result, null);
    });

    test('should retrieve height for valid coordinates', () {
      final map = Minimap(length: 10, data: Grid<Coord2D, int>.empty());
      map.add(x: 2, y: 3, height: 7);

      final result = map.get(x: 2, y: 3);

      expect(result, 7);
    });

    test('overwrites height value if the coordinates are the same', () {
      final map = Minimap(length: 10, data: Grid<Coord2D, int>.empty());
      map.add(x: 2, y: 3, height: 7);

      expect(map.get(x: 2, y: 3), 7);

      map.add(x: 2, y: 3, height: 10);

      expect(map.get(x: 2, y: 3), 10);
    });
  });
}