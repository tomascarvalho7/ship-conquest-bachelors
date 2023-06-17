import 'dart:math';

import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/immutable_collections/utils/extend_sequence.dart';
import 'package:ship_conquest/domain/game/minimap.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';
import 'package:ship_conquest/domain/utils/build_bezier.dart';
import 'package:ship_conquest/services/input_models/space/coord_2d_input_model.dart';
import 'package:ship_conquest/services/input_models/space/coordinate_input_model.dart';


/// Input model class representing input data of the game's minimap.
class MinimapInputModel {
  final Sequence<Coord2DInputModel> paths;
  final Sequence<CoordinateInputModel> islands;
  final int length;

  // Constructor to deserialize the input model from a JSON map.
  MinimapInputModel.fromJson(Map<String, dynamic> json)
      : length = json['size'],
        paths = Sequence(data: List<dynamic>.from(json['paths'])
            .map((e) => Coord2DInputModel.fromJson(e))
            .toList()
          ),
        islands = Sequence(data: List<dynamic>.from(json['islands'])
            .map((e) => CoordinateInputModel.fromJson(e))
            .toList());
}

// An extension on the [MinimapInputModel] class to convert it to an [Minimap] domain object.
extension Convert on MinimapInputModel {
  /// Converts the [MinimapInputModel] to a [Minimap] object.
  Minimap toMinimap() {
    // builds the Bézier curves from the received list of coordinates and applies a pulse
    // in 0.1 t increments where t is the interpolation value of the curves.
    final pathsPixels = Sequence(data:
      buildBeziers(paths.data.toCoord2DList()).expand((bezier) {
        var data = Sequence.empty();
        for (double t = 0.0; t <= 1.0; t += 0.1) {
          data = data + pulseAndFill(bezier.get(t).toCoord2D(), 10);
        }
        return data;
      }).toList()
    );

    return Minimap(
        length: length,
        data:
        pathsPixels.toGrid((element) => Coord2D(x: element.x, y: element.y), (element) => 0)
        +
        islands.toGrid((element) => Coord2D(x: element.x, y: element.y), (element) => element.z)
        );
  }
}

/// Creates a pulse around the point [center] with radius [radius] and returns a
/// [Sequence<Coord2D>] with all the points inside the pulse's circle.
Sequence<Coord2D> pulseAndFill(Coord2D center, int radius) {
  var res = Sequence<Coord2D>.empty();
  for (var y = -radius; y <= radius; y++) {
    final yF = y.toDouble();
    for (var x = -radius; x <= radius; x++) {
      final xF = x.toDouble();
      final distance = sqrt(pow(xF, 2) + pow(yF, 2));

      if (radius / distance >= 0.95) {
        final pos = center + Coord2D(x: x, y: y);

        res = res.put(pos);
      }
    }
  }

  return res;
}

