///
/// Generic Immutable class that extends the [Iterable]
/// class.
/// The [Sequence] class contains a immutable [List]
/// with non-variable elements.
///
class Sequence<T> extends Iterable<T> {
  final List<T> data;
  // constructor
  Sequence({required this.data});

  /// Represents an empty [Sequence].
  ///
  /// Creates a new instance of [Sequence] with an empty [data] list.
  Sequence.empty() : data = [];

  /// Retrieves the length of the current [Sequence].
  @override
  int get length => data.length;

  /// Retrieves the value at a given [index] from the [Sequence].
  T get(int index) => data[index];

  /// Adds a new [tile] to the [Sequence] and returns the new instance.
  Sequence<T> put(T tile) => Sequence(data: [...data, tile]);

  /// Replaces the element at [index] with the given [tile].
  /// Returns the new [Sequence] instance.
  Sequence<T> replace(int index, T tile) {
    final newData = [...data]; // create new list instance
    newData[index] = tile; // replace element
    return Sequence(data: newData);
  }

  /// Combine two [Sequence] instances.
  Sequence<T> plus(Sequence<T> other) => this + other;
  /// Combine two [Sequence] instances.
  Sequence<T> operator +(Sequence<T> other) => Sequence(data: [...data, ...other.data]);

  /// Creates a new [Sequence] containing only the elements
  /// that satisfy the given [condition].
  ///
  /// Returns a new [Sequence] instance with the filtered elements.
  Sequence<T> filter(bool Function(T) condition) => Sequence(data: [...data.where(condition)]);

  /// Creates a new [Sequence] containing only the elements that are instances of [N].
  ///
  /// Returns a new [Sequence] instance with the filtered elements.
  Sequence<N> filterInstance<N>() => Sequence(data: [...data.whereType<N>()]);

  /// Map the elements of the [Sequence] with the function [toElement].
  @override
  Sequence<K> map<K>(K Function(T value) toElement) => Sequence(data: data.map(toElement).toList());

  /// The iterator of the [Sequence].
  @override
  Iterator<T> get iterator => data.iterator;
}