import 'package:ship_conquest/domain/space/coord_2d.dart';

class Coord2DInputModel {
  final int x;
  final int y;

  Coord2DInputModel({required this.x, required this.y});

  Coord2DInputModel.fromJson(Map<String, dynamic> json)
      : x = json['x'],
        y = json['y'];
}

extension ConvertList on List<Coord2DInputModel> {
  toCoord2DList() {
    return map((coord) => Coord2D(x: coord.x, y: coord.y));
  }
}

extension Convert on Coord2DInputModel {
  Coord2D toCoord2D() =>
      Coord2D(x: x, y: y);
}
