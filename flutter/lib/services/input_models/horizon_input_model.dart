import 'package:ship_conquest/domain/space/coordinate.dart';
import 'package:ship_conquest/services/input_models/coordinate_input_model.dart';

import '../../domain/horizon.dart';
import 'island_input_model.dart';

class HorizonInputModel {
  final List<CoordinateInputModel> tiles;
  final List<IslandInputModel> islands;
  // constructor
  HorizonInputModel({required this.tiles, required this.islands});

  HorizonInputModel.fromJson(Map<String, dynamic> json)
    : tiles = List<dynamic>.from(json['tiles'])
      .map((e) => CoordinateInputModel.fromJson(e))
      .toList(),
    islands = List<dynamic>.from(json['islands'])
      .map((e) => IslandInputModel.fromJson(e))
      .toList();
}

extension Convert on HorizonInputModel {
  Horizon toHorizon() {
    return Horizon(
        tiles: tiles
            .map((value) => Coordinate(x: value.x, y: value.y, z: value.z))
            .toList(),
        islands: islands
            .map((value) => value.toIsland())
            .toList()
    );
  }
}
