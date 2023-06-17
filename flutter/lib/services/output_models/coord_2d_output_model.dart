/// Output model class representing a 2D coordinate with integer values
class Coord2DOutputModel {
  final int x;
  final int y;

  Coord2DOutputModel({required this.x, required this.y});

  Map<String, dynamic> toJson() =>
      {
        'x': x,
        'y': y,
      };
}


