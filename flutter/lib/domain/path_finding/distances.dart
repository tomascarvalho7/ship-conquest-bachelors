import 'dart:math';
import '../space/coord_2d.dart';

double calculateEuclideanDistance(Coord2D start, Coord2D end) {
  int dx = start.x - end.x;
  int dy = start.y - end.y;
  return sqrt((dx * dx + dy * dy).abs());
}

double calculateManhattanDistance(Coord2D start, Coord2D end) {
  return (start.x - end.x).abs() + (start.y - end.y).abs().toDouble();
}