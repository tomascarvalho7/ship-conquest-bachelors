import 'dart:math';
import 'package:ship_conquest/domain/space/coord_2d.dart';
import 'package:ship_conquest/domain/space/position.dart';

/// Calculate the Euclidean distance between two points.
///
/// [start] and [end] are [Position] instances.
double distance(Position start, Position end) {
  double dx = start.x - end.x;
  double dy = start.y - end.y;
  return sqrt((dx * dx + dy * dy).abs());
}

/// Calculate the Euclidean distance between two points.
///
/// [start] and [end] are [Coord2D] instances.
double euclideanDistance(Coord2D start, Coord2D end) {
  int dx = start.x - end.x;
  int dy = start.y - end.y;
  return sqrt((dx * dx + dy * dy).abs());
}

/// Calculate the Manhattan distance between two points.
///
/// [start] and [end] are [Coord2D] instances.
double manhattanDistance(Coord2D start, Coord2D end) {
  return (start.x - end.x).abs() + (start.y - end.y).abs().toDouble();
}