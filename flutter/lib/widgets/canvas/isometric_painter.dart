import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/space/position.dart';
import 'package:ship_conquest/domain/space/tile_state.dart';
import 'package:ship_conquest/domain/space/tiles_order.dart';
import 'package:ship_conquest/widgets/canvas/draw_cube.dart';
import '../../domain/color/color_gradient.dart';
import '../../domain/isometric/isometric_tile.dart';

class IsometricPainter extends CustomPainter {
  final double tileSize;
  final Animation<double> waveAnim;
  final Animation<double> fadeAnim;
  final TilesOrder<IsometricTile> tilesOrder;

  IsometricPainter({required this.tileSize, required this.waveAnim, required this.fadeAnim, required this.tilesOrder}) : super(repaint: waveAnim);

  @override
  void paint(Canvas canvas, Size size) {
    final length = tilesOrder.tiles.length;
    for (var i = 0; i < length; i++) {
      final tile = tilesOrder.tiles.get(i);
      final state = tilesOrder.tilesStates[tile.coord]!;
      double height = tile.height(waveAnim.value);

      drawCube(
          position: Position(
              x: tile.position.x,
              y: tile.position.y + height
          ),
          size: getSize(tileSize, state),
          tilePaint: tile.tilePaint(height),
          canvas: canvas
      );
    }
  }

  double getSize(double size, TileState state) {
    if (state == TileState.neutral) return size;
    if (state == TileState.fresh) return size * fadeAnim.value;
    return size * (1 - fadeAnim.value);
  }

  @override
  bool shouldRepaint(IsometricPainter oldDelegate) => false;
}