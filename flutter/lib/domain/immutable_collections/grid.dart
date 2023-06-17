///
/// Generic Immutable class.
/// The [Grid] class contains a immutable [Map]
/// with [Key] stored [Values].
///
class Grid<K, V> {
  // variables
  final Map<K, V> data;
  // constructor
  Grid({required this.data});

  // getters
  int get length => data.length;

  // methods

  /// Creates an empty [Grid].
  Grid.empty() : data = {};

  /// Retrieves the value associated with the specified [key].
  ///
  /// Throws an exception if the [key] is not present in the [Grid].
  V get(K key) => data[key]!;

  /// Retrieves the value associated with the specified [key] or
  /// returns null if the [key] is not present in the [Grid].
  V? getOrNull(K key) => data[key];

  /// Inserts or updates the [value] associated with the specified [key] in the [Grid].
  ///
  /// Returns a new [Grid] with the updated [Grid] after inserting or updating the [value] for the [key].
  Grid<K, V> put(K key, V value) => Grid(data: {...data, key: value});

  /// Combines the current [Grid] instance and the [other] [Grid] instance.
  ///
  /// Returns a new [Grid] instance with the combined grid from both instances.
  Grid<K, V> operator + (Grid<K, V> other) => Grid(data: {...data, ...other.data});

  /// Removes the entry with the specified [key] from the current [Grid].
  ///
  /// Returns a new [Grid] instance.
  Grid<K, V> delete(K key) {
    data.remove(key); // remove
    return Grid(data: {...data}); // return immutable instance
  }

  /// Applies a function given in [block] to each entry of the [Grid].
  Grid<K, N> map<N>(N Function(V value) block) =>
      Grid(data: {...data.map((key, value) => MapEntry(key, block(value)))});

  /// Checks if any of the elements present in the [Grid] satisfies the given [operator] function.
  bool any(bool Function(V any) operator) {
    if (data.isEmpty) return false;

    for (var value in data.values) {
      if (operator(value)) return true;
    }
    
    return false;
  }

  /// Applies the function [operator] to each pair of values of the [Grid].
  bool reduce(bool Function(V prevValue, V currValue) operator) {
    if (data.isEmpty) return false;

    var iterator = data.values.iterator..moveNext();
    var prevValue = iterator.current;
    while (iterator.moveNext()) {
      var currValue = iterator.current;
      if (!operator(prevValue, currValue)) {
        return false;
      }
      prevValue = currValue;
    }

    return true;
  }
}