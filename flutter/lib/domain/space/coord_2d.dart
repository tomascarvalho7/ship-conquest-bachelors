class Coord2D {
  final int x;
  final int y;

  Coord2D({required this.x, required this.y});

  @override
  int get hashCode => Object.hash(x, y);

  @override
  bool operator == (Object other)  =>
      other is Coord2D && other.x == x && other.y == y;
}