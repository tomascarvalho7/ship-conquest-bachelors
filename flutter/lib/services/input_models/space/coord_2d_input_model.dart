import 'package:ship_conquest/domain/space/coord_2d.dart';

/// Input model class representing input data for 2D coordinate with integer properties.
class Coord2DInputModel {
  final int x;
  final int y;

  // Constructor to deserialize the input model from a JSON map.
  Coord2DInputModel.fromJson(Map<String, dynamic> json)
      : x = json['x'],
        y = json['y'];
}

// An extension on the List<Coord2DInputModel> class to convert it to an List<Coord2D> domain object.
extension ConvertList on List<Coord2DInputModel> {
  /// Converts the [List<Coord2DInputModel>] to a [List<Coord2D>] object.
  List<Coord2D> toCoord2DList() {
    return map((coord) => Coord2D(x: coord.x, y: coord.y)).toList();
  }
}

// An extension on the Coord2DInputModel class to convert it to an Coord2D domain object.
extension Convert on Coord2DInputModel {
/// Converts the [Coord2DInputModel] to a [Coord2D] object.
  Coord2D toCoord2D() =>
      Coord2D(x: x, y: y);
}
