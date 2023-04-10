
import 'package:flutter/cupertino.dart';

import '../../../../domain/color/color_gradient.dart';
import '../../../../domain/isometric/isometric_tile.dart';
import '../../../../domain/space/coordinate.dart';
import '../../../../main.dart';
import '../../../canvas/isometric_painter.dart';

class TilesView extends StatelessWidget {
  final Animation<double> animation;
  final List<Coordinate> tiles;
  final ColorGradient colorGradient;
  final Widget? child;

  const TilesView({super.key, required this.animation, required this.tiles, required this.colorGradient, this.child});

  // optimizations
  final double tileSizeWidthHalf = tileSize / 2;
  final double tileSizeHeightHalf = tileSize / 4;

  @override
  Widget build(BuildContext context) {
    List<IsometricTile> isoTiles = tiles.map((coord) {
      if (coord.z == 0) {
        return IsometricTile.fromWaterTile(
            coordinate: coord,
            tileSize: tileSize,
            color: colorGradient.get(coord.z)
        );
      } else {
        return IsometricTile.fromTerrainTile(
            coordinate: coord,
            tileSize: tileSize,
            color: colorGradient.get(coord.z)
        );
      }
    }).toList(growable: false);

    return CustomPaint(
        painter: IsometricPainter(
            tileSize: tileSize,
            animation: animation,
            tiles: isoTiles
        )
    );
  }
}