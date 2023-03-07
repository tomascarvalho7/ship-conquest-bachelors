import 'package:flutter/cupertino.dart';

import '../domain/chunk.dart';
import '../domain/coordinate.dart';
import 'grid.dart';

class ChunkWidget extends StatelessWidget {
  final Chunk chunk;
  final AnimationController controller;
  final double tileSize;
  const ChunkWidget({super.key, required this.chunk, required this.controller, required this.tileSize});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(chunk.tiles.length, (index) {
        Coordinate coord = chunk.tiles[index];
        return TileWrapper(x: coord.x, y: coord.y, z: coord.z, controller: controller);
      }),
    );
  }
}