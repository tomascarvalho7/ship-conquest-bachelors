import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/providers/image_gradient.dart';
import 'package:ship_conquest/providers/tile_manager.dart';

import '../domain/chunk.dart';
import '../domain/coordinate.dart';
import 'grid.dart';

class ChunkWidget extends StatelessWidget {
  final Chunk chunk;
  final AnimationController controller;
  final double tileSize;
  final TileManager tileManager;
  const ChunkWidget({super.key, required this.chunk, required this.controller, required this.tileSize, required this.tileManager});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(chunk.tiles.length, (index) {
        Coordinate coord = chunk.tiles[index];
        return TileWrapper(
            x: coord.x,
            y: coord.y,
            z: coord.z,
            controller: controller,
            image: tileManager.pngList[coord.z]
        );
      }),
    );
  }
}