import 'package:ship_conquest/domain/coordinate.dart';
import 'package:ship_conquest/services/input_models/coordinate_input_model.dart';

import '../../domain/chunk.dart';

class ChunkInputModel {
  final List<CoordinateInputModel> tiles;

  ChunkInputModel({required this.tiles});

  ChunkInputModel.fromJson(Map<String, dynamic> json)
    : tiles = List<dynamic>.from(json['tiles'])
      .map((e) => CoordinateInputModel.fromJson(e))
      .toList();
}

extension Convert on ChunkInputModel {
  Chunk toChunk(int chunkSize, Coordinate coordinates) {
    return Chunk(
        size: chunkSize,
        coordinates: coordinates,
        tiles: tiles
            .map((value) => Coordinate(x: value.x, y: value.y, z: value.z))
            .toList());
  }
}
