import 'package:flutter/cupertino.dart';

class Position {
  final double x;
  final double y;
  const Position({required this.x, required this.y});

  Offset toOffset() => Offset(x, y);

  Position operator +(Position other) => Position(x: x + other.x, y: y + other.y);
  Position operator -(Position other) => Position(x: x - other.x, y: y - other.y);
}