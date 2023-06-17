import 'package:flutter_test/flutter_test.dart';
import 'package:ship_conquest/domain/immutable_collections/grid.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';

void main() {
  group('Grid', () {
    test('should create an empty Grid', () {
      final grid = Grid<int, String>.empty();

      expect(grid.length, 0);
      expect(grid.data, {});
    });

    test('should put and retrieve values correctly', () {
      final grid = Grid<int, String>.empty();

      final updatedGrid = grid.put(1, 'One');

      expect(updatedGrid.length, 1);
      expect(updatedGrid.get(1), 'One');
    });

    test('should combine two grids correctly', () {
      final grid1 = Grid<int, String>.empty().put(1, 'One');
      final grid2 = Grid<int, String>.empty().put(2, 'Two');

      final combinedGrid = grid1 + grid2;

      expect(combinedGrid.length, 2);
      expect(combinedGrid.get(1), 'One');
      expect(combinedGrid.get(2), 'Two');
    });

    test('should delete values correctly', () {
      final grid = Grid<int, String>.empty().put(1, 'One').put(2, 'Two');

      final updatedGrid = grid.delete(1);

      expect(updatedGrid.length, 1);
      expect(updatedGrid.getOrNull(1), null);
      expect(updatedGrid.get(2), 'Two');
    });

    test('should map values correctly', () {
      final grid = Grid<int, int>.empty().put(1, 1).put(2, 2).put(3, 3);

      final mappedGrid = grid.map((value) => value * value);

      expect(mappedGrid.length, 3);
      expect(mappedGrid.get(1), 1);
      expect(mappedGrid.get(2), 4);
      expect(mappedGrid.get(3), 9);
    });

    test('should check if any value satisfies the condition', () {
      final grid = Grid<int, int>.empty().put(1, 1).put(2, 2).put(3, 3);

      final anyGreaterThanTwo = grid.any((value) => value > 2);
      final anyEvenValue = grid.any((value) => value % 2 == 0);

      expect(anyGreaterThanTwo, true);
      expect(anyEvenValue, true);
    });

    test('should reduce values correctly', () {
      final grid1 = Grid<int, int>.empty().put(1, 1).put(2, 2).put(3, 3);
      final grid2 = Grid<int, int>.empty().put(1, 1).put(2, 2).put(3, -4);

      final allValuesGreaterThanZero1 =
      grid1.reduce((prev, curr) => prev > 0 && curr > 0);
      final allValuesGreaterThanZero2 =
      grid2.reduce((prev, curr) => prev > 0 && curr > 0);

      expect(allValuesGreaterThanZero1, true);
      expect(allValuesGreaterThanZero2, false);
    });
  });

  group('Sequence', () {
    test('should create an empty Sequence', () {
      // Arrange & Act
      final sequence = Sequence<int>.empty();

      // Assert
      expect(sequence.length, 0);
      expect(sequence.data, []);
    });

    test('should put and retrieve values correctly', () {
      // Arrange
      final sequence = Sequence<int>.empty();

      // Act
      final updatedSequence = sequence.put(1);

      // Assert
      expect(updatedSequence.length, 1);
      expect(updatedSequence.get(0), 1);
    });

    test('should replace values correctly', () {
      // Arrange
      final sequence = Sequence<int>.empty().put(1).put(2).put(3);

      // Act
      final updatedSequence = sequence.replace(1, 10);

      // Assert
      expect(updatedSequence.length, 3);
      expect(updatedSequence.get(0), 1);
      expect(updatedSequence.get(1), 10);
      expect(updatedSequence.get(2), 3);
    });

    test('should combine two sequences correctly', () {
      // Arrange
      final sequence1 = Sequence<int>.empty().put(1).put(2);
      final sequence2 = Sequence<int>.empty().put(3).put(4);

      // Act
      final combinedSequence = sequence1 + sequence2;

      // Assert
      expect(combinedSequence.length, 4);
      expect(combinedSequence.get(0), 1);
      expect(combinedSequence.get(1), 2);
      expect(combinedSequence.get(2), 3);
      expect(combinedSequence.get(3), 4);
    });

    test('should filter values correctly', () {
      // Arrange
      final sequence =
      Sequence<int>.empty().put(1).put(2).put(3).put(4).put(5).put(6);

      // Act
      final filteredSequence = sequence.filter((value) => value % 2 == 0);

      // Assert
      expect(filteredSequence.length, 3);
      expect(filteredSequence.get(0), 2);
      expect(filteredSequence.get(1), 4);
      expect(filteredSequence.get(2), 6);
    });

    test('should filter instances correctly', () {
      // Arrange
      final sequence = Sequence<Object>.empty()
          .put(1)
          .put('two')
          .put(3.0)
          .put('four')
          .put(5)
          .put('six');

      // Act
      final filteredSequence = sequence.filterInstance<String>();

      // Assert
      expect(filteredSequence.length, 3);
      expect(filteredSequence.get(0), 'two');
      expect(filteredSequence.get(1), 'four');
    });

    test('should map values correctly', () {
      // Arrange
      final sequence = Sequence<int>.empty().put(1).put(2).put(3);

      // Act
      final mappedSequence = sequence.map((value) => value * 2);

      // Assert
      expect(mappedSequence.length, 3);
      expect(mappedSequence.get(0), 2);
      expect(mappedSequence.get(1), 4);
      expect(mappedSequence.get(2), 6);
    });

    test('should iterate over values correctly', () {
      // Arrange
      final sequence = Sequence<int>.empty().put(1).put(2).put(3);

      // Act
      final values = sequence.toList();

      // Assert
      expect(values.length, 3);
      expect(values[0], 1);
      expect(values[1], 2);
      expect(values[2], 3);
    });
  });
}