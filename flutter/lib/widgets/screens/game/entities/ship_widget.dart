import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/coordinate.dart';
import 'package:ship_conquest/domain/position.dart';

class ShipWidget extends StatelessWidget {
  final Animation<double> animation;
  final Coordinate coord;
  final double tileSize;
  // constructor
  ShipWidget({super.key, required this.coord, required this.tileSize, required this.animation});

  // optimizations
  late final scale = tileSize * 4;
  late final double tileSizeWidthHalf = tileSize / 2;
  late final double tileSizeHeightHalf = tileSizeWidthHalf / 2;
  late final position = Position(
    x: (coord.x - coord.y) * tileSizeWidthHalf,
    y: (coord.x + coord.y) * tileSizeHeightHalf,
  );
  late final double waveOffset = (coord.x + coord.y) / -3;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
          animation: animation,
          child: Image.asset(
            'assets/images/ship_dark.png',
            width: scale,
            height: scale,
          ),
          builder: (context, child) =>
              Transform.translate(
                  offset: Offset(
                      position.x,
                      position.y + sin(animation.value + waveOffset) * tileSizeHeightHalf
                  ),
                  child: child
              )
      )
    );
  }
}