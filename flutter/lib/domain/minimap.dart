import 'dart:collection';
import 'dart:ui';

import 'space/coord_2d.dart';

class Minimap {
  final int length;
  final HashMap<Coord2D, int> data;

  Minimap({required this.length, required this.data});

  void add({required int x, required int y, required int height})
    => data[Coord2D(x: x, y: y)] = height;

  int? get({required int x, required int y}) => data[Coord2D(x: x, y: y)];
}