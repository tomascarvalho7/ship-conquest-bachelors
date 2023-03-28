import 'dart:collection';

import 'package:ship_conquest/domain/color_gradient.dart';
import 'package:ship_conquest/domain/minimap.dart';
import 'package:ship_conquest/services/input_models/coordinate_input_model.dart';

import '../../domain/coord_2d.dart';

class MinimapInputModel {
  final List<CoordinateInputModel> points;
  final int length;

  MinimapInputModel.fromJson(Map<String, dynamic> json)
    : length = json['size'],
      points = List<dynamic>.from(json['points'])
        .map((e) => CoordinateInputModel.fromJson(e))
        .toList();
}

extension Convert on MinimapInputModel {
  Minimap toMinimap(ColorGradient colorGradient) =>
      Minimap(
        length: length,
        pixels: HashMap
            .fromIterable(
            points,
            key: (i) => Coord2D(x: points[i].x, y: points[i].y),
            value: (i) => colorGradient.get(points[i].z)
        )
      );
}