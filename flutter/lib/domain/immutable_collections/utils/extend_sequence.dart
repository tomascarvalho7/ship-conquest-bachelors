import 'package:ship_conquest/domain/immutable_collections/grid.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';

///
/// Generic Extension method to add functionality
/// to the [Sequence] class that depend on other [Components]
///
extension ExtendSequence<T> on Sequence<T> {
  /// [Sequence] to [Grid] method
  Grid<K, V> toGrid<K, V>(K Function(T element) getKey, V Function(T element) getValue) =>
      Grid(data: {
        for (var element in data) getKey(element) : getValue(element)
      });
}