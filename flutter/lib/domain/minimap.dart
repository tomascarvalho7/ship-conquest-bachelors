import 'dart:collection';
import 'dart:ui';

import 'coord_2d.dart';

class Minimap {
  final int length;
  final HashMap<Coord2D, Color> pixels;

  Minimap({required this.length, required this.pixels});

  void add({required int x, required int y, required Color color})
    => pixels[Coord2D(x: x, y: y)] = color;

  Color? get({required int x, required int y}) => pixels[Coord2D(x: x, y: y)];
}