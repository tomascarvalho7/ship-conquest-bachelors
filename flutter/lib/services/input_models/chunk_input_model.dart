import 'package:ship_conquest/domain/coordinate.dart';
import 'package:ship_conquest/services/input_models/coordinate_input_model.dart';

import '../../domain/chunk.dart';

class ChunkInputModel {
  final List<CoordinateInputModel> tiles;

  ChunkInputModel({required this.tiles});

  factory ChunkInputModel.fromJson(
      Map<String, dynamic> json) {
    return ChunkInputModel(tiles: List<CoordinateInputModel>.from(json['tiles'] ?? []));
  }
}

extension Convert on ChunkInputModel {
  Chunk toChunk(int size, Coordinate coordinates) {
    return Chunk(
        size: size,
        coordinates: coordinates,
        tiles: tiles.map((value) {
          return Coordinate(x: value.x, y: value.y, z: value.z);
        }).toList());
  }
}
