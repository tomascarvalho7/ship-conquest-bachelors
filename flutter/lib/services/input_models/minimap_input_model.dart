import 'dart:collection';

import 'package:ship_conquest/domain/color/color_gradient.dart';
import 'package:ship_conquest/domain/minimap.dart';
import 'package:ship_conquest/services/input_models/coord_2d_input_model.dart';
import 'package:ship_conquest/services/input_models/coordinate_input_model.dart';

import '../../domain/space/coord_2d.dart';

class MinimapInputModel {
  final List<Coord2DInputModel> paths;
  final List<CoordinateInputModel> islands;
  final int length;

  MinimapInputModel.fromJson(Map<String, dynamic> json)
      : length = json['size'],
        paths = List<dynamic>.from(json['paths'])
            .map((e) => Coord2DInputModel.fromJson(e))
            .toList(),
        islands = List<dynamic>.from(json['islands'])
            .map((e) => CoordinateInputModel.fromJson(e))
            .toList();
}

extension Convert on MinimapInputModel {
  Minimap toMinimap() {
    final resList = islands + paths.map((e) => CoordinateInputModel(x: e.x, y: e.y, z: 0)).toList();

    return Minimap(
        length: length,
        data: HashMap.fromIterable(resList,
            key: (i) => Coord2D(x: resList[i].x, y: resList[i].y),
            value: (i) => resList[i].z));
  }
}
