import 'dart:math';

import 'package:ship_conquest/domain/space/map_position.dart';

double calculateEuclideanDistance(MapPosition start, MapPosition end) {
  int dx = start.x - end.x;
  int dy = start.y - end.y;
  return sqrt((dx * dx + dy * dy).abs().toDouble());
}

double calculateManhattanDistance(MapPosition start, MapPosition end) {
  return (start.x - end.x).abs() + (start.y - end.y).abs().toDouble();
}