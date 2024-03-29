import 'package:flutter/material.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';

/// Represents a position in a 2D space with double type coordinates.
class Position {
  final double x;
  final double y;
  const Position({required this.x, required this.y});

  // utility functions to help manage Position instances
  Offset toOffset() => Offset(x, y);
  Coord2D toCoord2D() => Coord2D(x: x.round(), y: y.round());

  Position operator +(Position other) => Position(x: x + other.x, y: y + other.y);
  Position operator -(Position other) => Position(x: x - other.x, y: y - other.y);
  Position operator *(double other) => Position(x: x * other, y: y * other);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Position && runtimeType == other.runtimeType && x == other.x && y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() => '(x = $x, y = $y)';
}