import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/isometric_tile.dart';
import 'package:ship_conquest/domain/position.dart';
import 'package:vector_math/vector_math_64.dart';

import 'coordinate.dart';

class IsometricTilesFlowDelegate extends FlowDelegate {
  final Animation<num> animation;
  List<Coordinate> tiles;
  final double tileSize;
  late final double tileSizeWidthHalf = tileSize / 2;
  late final double tileSizeHeightHalf = tileSizeWidthHalf / 2;
  late final List<IsometricTile> isometricTiles;

  IsometricTilesFlowDelegate({required this.animation, required this.tiles, required this.tileSize}): super(repaint: animation) {
    isometricTiles = tiles.map((coord) {
      if (coord.z == 0) {
        return WaterTile(coordinate: coord, tileSizeWidthHalf: tileSizeWidthHalf, tileSizeHeightHalf: tileSizeHeightHalf, animation: animation);
      } else {
        return TerrainTile(coordinate: coord, tileSizeWidthHalf: tileSizeWidthHalf, tileSizeHeightHalf: tileSizeHeightHalf);
      }
    }).toList(growable: false);
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    for(int i = 0; i < tiles.length; i++) {
      IsometricTile tile = isometricTiles[i];
      context.paintChild(
          i,
          transform: Matrix4.compose(
            Vector3(
                tile.position.x,
                tile.position.y,
                0
            ),
            Quaternion.identity(),
            Vector3.all(.16)
          )
      );
    }
  }

  @override
  bool shouldRepaint(IsometricTilesFlowDelegate oldDelegate) {
    // or just animation !=
    return animation.value != oldDelegate.animation.value;
  }
}









