import 'package:ship_conquest/domain/immutable_collections/grid.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';

///
/// Generic Extension method to add functionality
/// to the [Grid] class that depend on other [Components]
///
extension ExtendGrid<K, V> on Grid<K, V> {
  /// [Grid] to [Sequence] method
  Sequence<V> toSequence() => Sequence(data: data.values.toList());
}
