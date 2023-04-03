import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/space/position.dart';
import 'package:ship_conquest/widgets/canvas/draw_cube.dart';
import '../../domain/color/color_gradient.dart';
import '../../domain/isometric/isometric_tile.dart';

class IsometricPainter extends CustomPainter {
  final double tileSize;
  final Animation<double> animation;
  final List<IsometricTile> tiles;

  IsometricPainter({required this.tileSize, required this.animation, required this.tiles}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final length = tiles.length;
    for (var i = 0; i < length; i++) {
      final tile = tiles[i];
      double height = tile.height(animation.value);

      drawCube(
          position: Position(
              x: tile.position.x,
              y: tile.position.y + height
          ),
          size: tileSize,
          tilePaint: tile.tilePaint(height),
          canvas: canvas
      );
    }
  }

  @override
  bool shouldRepaint(IsometricPainter oldDelegate) => false;
}