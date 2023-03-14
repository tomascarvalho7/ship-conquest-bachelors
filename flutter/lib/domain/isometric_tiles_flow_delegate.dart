import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/position.dart';
import 'package:vector_math/vector_math_64.dart';

import 'coordinate.dart';

class IsometricTilesFlowDelegate extends FlowDelegate {
  final Animation<num> animation;
  List<Coordinate> tiles;
  final double tileSize;
  late final double tileSizeWidthHalf = tileSize / 2;
  late final double tileSizeHeightHalf = tileSizeWidthHalf / 2;
  late final List<Position> tilePositions;
  late final List<double> tileWaveOffsets;

  IsometricTilesFlowDelegate({required this.animation, required this.tiles, required this.tileSize}): super(repaint: animation) {
    tilePositions = tiles.map((tile) => Position(
        x: (tile.x - tile.y) * tileSizeWidthHalf,
        y: (tile.x + tile.y - (tile.z / 10)) * tileSizeHeightHalf,
      )
    ).toList(growable: false);

    tileWaveOffsets = tiles.map(
            (tile) => (tile.x + tile.y) / -3)
        .toList(growable: false);

    /*for (var e in tiles) {
      print("coords: ${e.x}, ${e.y}, ${e.z}");
    }*/
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    for(int i = 0; i < tiles.length; i++) {
      Position tilePos = tilePositions[i];
      //double waveOffset = tileWaveOffsets[i];
      context.paintChild(
          i,
          transform: Matrix4.compose(
            Vector3(
                tilePos.x,
                tilePos.y/* + sin(animation.value + waveOffset) * tileSizeWidthHalf*/,
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