import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/space/position.dart';

class ShipWidget extends StatelessWidget {
  final Animation<double> animation;
  final Position position;
  final double tileSize;
  // constructor
  ShipWidget({super.key, required this.position, required this.tileSize, required this.animation});

  // optimizations
  late final scale = tileSize * 4;
  late final double waveOffset = (position.x + position.y) / -3;

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
                      position.y + sin(animation.value + waveOffset) * tileSize / 4
                  ),
                  child: child
              )
      )
    );
  }
}