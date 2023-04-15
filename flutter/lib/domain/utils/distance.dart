import 'dart:math';
import 'package:ship_conquest/domain/space/position.dart';

import '../space/coord_2d.dart';

double distance(Position start, Position end) {
  double dx = start.x - end.x;
  double dy = start.y - end.y;
  return sqrt((dx * dx + dy * dy).abs());
}

double euclideanDistance(Coord2D start, Coord2D end) {
  int dx = start.x - end.x;
  int dy = start.y - end.y;
  return sqrt((dx * dx + dy * dy).abs());
}

double manhattanDistance(Coord2D start, Coord2D end) {
  return (start.x - end.x).abs() + (start.y - end.y).abs().toDouble();
}