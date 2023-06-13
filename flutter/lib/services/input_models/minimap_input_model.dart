import 'dart:collection';
import 'dart:math';

import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/immutable_collections/utils/extend_sequence.dart';
import 'package:ship_conquest/domain/minimap.dart';
import 'package:ship_conquest/domain/utils/build_bezier.dart';
import 'package:ship_conquest/domain/utils/distance.dart';
import 'package:ship_conquest/services/input_models/coord_2d_input_model.dart';
import 'package:ship_conquest/services/input_models/coordinate_input_model.dart';

import '../../domain/space/coord_2d.dart';

class MinimapInputModel {
  final Sequence<Coord2DInputModel> paths;
  final Sequence<CoordinateInputModel> islands;
  final int length;

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

extension Convert on MinimapInputModel {
  Minimap toMinimap() {
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

