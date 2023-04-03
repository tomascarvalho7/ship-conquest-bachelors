import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/isometric/isometric_tile_paint.dart';
import 'package:ship_conquest/main.dart';
import 'package:ship_conquest/widgets/canvas/draw_cube.dart';

import '../../domain/space/position.dart';

class TestPainter extends CustomPainter {
  final Animation<int> animation;

  TestPainter(this.animation) : super(repaint: animation);

  final colorStart = const Color.fromRGBO(253, 29, 29, 1.0);
  final colorEnd = const Color.fromRGBO(252, 176, 69, 1.0);

  @override
  void paint(Canvas canvas, Size size) {
    for(int x = 0; x < 35; x++) {
      for(int y = 0; y < 35; y++) {
        int percent = animation.value < 50 ? animation.value : 100 - animation.value;

        drawCube(
            position: Position(x: x * tileSize, y: y * tileSize),
            size: tileSize,
            tilePaint: IsometricTilePaint(
                color: Color.lerp(colorStart, colorEnd, ((percent + y + x) / 100.0))!
            ),
            canvas: canvas
        );
      }
    }
  }

  @override
  bool shouldRepaint(TestPainter oldDelegate) => false;
}