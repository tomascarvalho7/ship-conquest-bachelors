import 'package:ship_conquest/domain/space/position.dart';

/// Represents a 2D coordinate with integer values.
class Coord2D {
  final int x;
  final int y;

  Coord2D({required this.x, required this.y});

  @override
  int get hashCode => Object.hash(x, y);

  //functions to operate with Coord2D instances
  Coord2D operator -(Coord2D other) => Coord2D(x: x - other.x, y: y - other.y);
  Coord2D operator +(Coord2D other) => Coord2D(x: x + other.x, y: y + other.y);
  Position operator *(double other) => Position(x: x * other, y: y * other);

  @override
  bool operator == (Object other)  =>
      other is Coord2D && other.x == x && other.y == y;

  @override
  String toString() => 'Coord(x = $x, y = $y)\n';
  Position toPosition() => Position(x: x.toDouble(), y: y.toDouble());
}