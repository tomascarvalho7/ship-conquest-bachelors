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


