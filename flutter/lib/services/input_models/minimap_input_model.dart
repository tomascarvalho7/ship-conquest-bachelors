import 'dart:collection';
import 'dart:math';

import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
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
        for (double t = 0; t <= 1; t += 0.1) {
          return pulseAndFill(bezier.get(t).toCoord2D(), 10);
        }
        return [];
      }).toList()
    );

    return Minimap(
        length: length,
        data:
          islands.toGrid((element) => Coord2D(x: element.x, y: element.y), (element) => element.z)
          +
          pathsPixels.toGrid((element) => Coord2D(x: element.x, y: element.y), (element) => 0)
        );
  }
}

Sequence<Coord2D> fillEllipse(List<Coord2D> points, List<Coord2D> focusPoints, double major) {
  var res = Sequence<Coord2D>.empty();
  // find the ellipse's bounding box
  int minX = points.map((p) => p.x).reduce(min);
  int maxX = points.map((p) => p.x).reduce(max);
  int minY = points.map((p) => p.y).reduce(min);
  int maxY = points.map((p) => p.y).reduce(max);

  // iterate in the ellipse's bounding box and add the tiles that are inside the ellipse
  for (int x = minX; x <= maxX; x++) {
    for (int y = minY; y <= maxY; y++) {
      final currCoord = Coord2D(x: x, y: y);
      if (isInsideEllipse(currCoord, focusPoints, major)) {
        res.put(currCoord);
      }
    }
  }
  return res;
}

bool isInsideEllipse(Coord2D point, List<Coord2D> focusPoints, double a) {
  // in an ellipse, the sum of distances of every point to the focus points is less than the semimajor
  double l1 = euclideanDistance(point, focusPoints[0]);
  double l2 = euclideanDistance(point, focusPoints[1]);
  return l1 + l2 <= a;
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

