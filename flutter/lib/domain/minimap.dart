import 'dart:collection';
import 'dart:ui';

import 'package:ship_conquest/domain/immutable_collections/grid.dart';

import 'space/coord_2d.dart';

class Minimap {
  final int length;
  Grid<Coord2D, int> data;

  Minimap({required this.length, required this.data});

  void add({required int x, required int y, required int height})
    => data = data.put(Coord2D(x: x, y: y), height);

  int? get({required int x, required int y}) => data.getOrNull(Coord2D(x: x, y: y));
}