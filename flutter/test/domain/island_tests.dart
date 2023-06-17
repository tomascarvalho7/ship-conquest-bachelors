import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:ship_conquest/domain/island/island.dart';
import 'package:ship_conquest/domain/island/island_presentation.dart';
import 'package:ship_conquest/domain/island/utils.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';
import 'package:ship_conquest/domain/space/position.dart';
import 'package:ship_conquest/utils/constants.dart';

void main() {
  group('Presentation', () {
    test('should get the island label correctly', () {
      final ownedIsland = OwnedIsland(id: 0, coordinate: Coord2D(x: 10, y: 10), radius: 20, incomePerHour: 25, username: 'John', owned: true);
      final enemyIsland = OwnedIsland(id: 2, coordinate: Coord2D(x: 30, y: 30), radius: 20, incomePerHour: 25, username: 'Jane', owned: false);
      final wildIsland = WildIsland(id: 4, coordinate: Coord2D(x: 50, y: 50), radius: 20);

      expect(ownedIsland.getIslandLabel(), 'Friendly Island');
      expect(enemyIsland.getIslandLabel(), 'Enemy Island');
      expect(wildIsland.getIslandLabel(), 'Wild Island');
    });

    test('should get the island details correctly', () {
      final ownedIsland = OwnedIsland(id: 0, coordinate: Coord2D(x: 10, y: 10), radius: 20, incomePerHour: 25, username: 'John', owned: true);
      final enemyIsland = OwnedIsland(id: 2, coordinate: Coord2D(x: 30, y: 30), radius: 20, incomePerHour: 25, username: 'Jane', owned: false);
      final wildIsland = WildIsland(id: 4, coordinate: Coord2D(x: 50, y: 50), radius: 20);

      expect(ownedIsland.getIslandDetails(), 'already owned island');
      expect(enemyIsland.getIslandDetails(), 'belonging to Jane forces');
      expect(wildIsland.getIslandDetails(), 'yet undiscovered island');
    });

    test('should get the island color correctly', () {
      final ownedIsland = OwnedIsland(id: 0, coordinate: Coord2D(x: 10, y: 10), radius: 20, incomePerHour: 25, username: 'John', owned: true);
      final enemyIsland = OwnedIsland(id: 2, coordinate: Coord2D(x: 30, y: 30), radius: 20, incomePerHour: 25, username: 'Jane', owned: false);
      final wildIsland = WildIsland(id: 4, coordinate: Coord2D(x: 50, y: 50), radius: 20);

      expect(ownedIsland.getIslandColor(), const Color.fromRGBO(56, 86, 162, 1.0));
      expect(enemyIsland.getIslandColor(), const Color.fromRGBO(162, 56, 56, 1.0));
      expect(wildIsland.getIslandColor(), const Color.fromRGBO(56, 162, 110, 1.0));
    });
  });

  group('Utils', () {
    test('should check if position is close to island correctly', () {
      // Arrange
      final ownedIsland = OwnedIsland(id: 0, coordinate: Coord2D(x: 10, y: 10), radius: 20, incomePerHour: 25, username: 'John', owned: true);
      final wildIsland = WildIsland(id: 4, coordinate: Coord2D(x: 20, y: 20), radius: 20);
      const positionClose = Position(x: 15, y: 15);
      const positionFar = Position(x: 100, y: 100);

      // Act & Assert
      expect(ownedIsland.isCloseTo(positionClose), isTrue);
      expect(wildIsland.isCloseTo(positionClose), isTrue);
      expect(ownedIsland.isCloseTo(positionFar), isFalse);
      expect(wildIsland.isCloseTo(positionFar), isFalse);
    });

    test('should check if island is owned by user correctly', () {
      // Arrange
      final ownedIsland = OwnedIsland(id: 0, coordinate: Coord2D(x: 10, y: 10), radius: 20, incomePerHour: 25, username: 'John', owned: true);
      final wildIsland = WildIsland(id: 4, coordinate: Coord2D(x: 20, y: 20), radius: 20);

      // Act & Assert
      expect(ownedIsland.isOwnedByUser(), isTrue);
      expect(wildIsland.isOwnedByUser(), isFalse);
    });

    test('should retrieve the conquest cost of an island correctly', () {
      // Arrange
      final ownedIsland = OwnedIsland(id: 0, coordinate: Coord2D(x: 10, y: 10), radius: 20, incomePerHour: 25, username: 'John', owned: true);
      final wildIsland = WildIsland(id: 4, coordinate: Coord2D(x: 20, y: 20), radius: 20);

      // Act & Assert
      expect(ownedIsland.conquestCost(), ownedIslandCost);
      expect(wildIsland.conquestCost(), wildIslandCost);
    });
  });
}