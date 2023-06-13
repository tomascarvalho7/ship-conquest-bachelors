import 'package:ship_conquest/domain/immutable_collections/sequence.dart';

import '../grid.dart';

extension ExtendSequence<T> on Sequence<T> {
  Grid<K, V> toGrid<K, V>(K Function(T element) getKey, V Function(T element) getValue) =>
      Grid(data: {
        for (var element in data) getKey(element) : getValue(element)
      });
}