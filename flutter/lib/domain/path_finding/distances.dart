import 'dart:math';
import '../space/position.dart';

double calculateEuclideanDistance(Position start, Position end) {
  double dx = start.x - end.x;
  double dy = start.y - end.y;
  return sqrt((dx * dx + dy * dy).abs());
}

double calculateManhattanDistance(Position start, Position end) {
  return (start.x - end.x).abs() + (start.y - end.y).abs();
}