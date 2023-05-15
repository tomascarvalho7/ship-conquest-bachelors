import 'package:ship_conquest/domain/immutable_collections/sequence.dart';

class Grid<K, V> {
  final Map<K, V> data;
  // constructor
  Grid({required this.data});

  Grid.empty() : data = {};

  int get length => data.length;

  V get(K key) => data[key]!;

  V? getOrNull(K key) => data[key];

  Grid<K, V> put(K key, V value) => Grid(data: {...data, key: value});

  Grid<K, V> delete(K key) {
    data.remove(key); // remove
    return Grid(data: {...data}); // return immutable instance
  }

  Grid<K, N> map<N>(N Function(V value) block) =>
      Grid(data: {...data.map((key, value) => MapEntry(key, block(value)))});

  bool any(bool Function(V any) operator) {
    if (data.isEmpty) return false;

    for (var value in data.values) {
      if (operator(value)) return true;
    }
    
    return false;
  }

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

  Sequence<V> toSequence() => Sequence(data: data.values.toList());
}