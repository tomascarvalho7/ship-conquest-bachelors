import 'package:ship_conquest/domain/space/coordinate.dart';
import 'package:ship_conquest/services/input_models/coordinate_input_model.dart';

import '../../domain/tile/tile_list.dart';

class ChunkInputModel {
  final List<CoordinateInputModel> tiles;

  ChunkInputModel({required this.tiles});

  ChunkInputModel.fromJson(Map<String, dynamic> json)
    : tiles = List<dynamic>.from(json['tiles'])
      .map((e) => CoordinateInputModel.fromJson(e))
      .toList();
}

extension Convert on ChunkInputModel {
  TileList toTileList() {
    return TileList(
        tiles: tiles
            .map((value) => Coordinate(x: value.x, y: value.y, z: value.z))
            .toList());
  }
}
