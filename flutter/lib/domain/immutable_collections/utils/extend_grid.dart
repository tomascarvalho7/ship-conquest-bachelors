import '../grid.dart';
import '../sequence.dart';

///
/// Generic Extension methods to add functionalities
/// to the [Grid] class that depend on other [Components]
///
extension ExtendGrid<K, V> on Grid<K, V> {
  /// [Grid] to [Sequence] method
  Sequence<V> toSequence() => Sequence(data: data.values.toList());
}