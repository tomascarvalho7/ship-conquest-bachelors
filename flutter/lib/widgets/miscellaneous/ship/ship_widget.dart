import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/widgets/miscellaneous/ship/ship_view.dart';

import '../../../domain/isometric/isometric.dart';
import '../../../domain/ship/ship.dart';
import '../../../utils/constants.dart';

class ShipWidget extends StatelessWidget {
  final Animation<double> waveAnim;
  final Ship ship;
  final double tileSize;
  // constructor
  ShipWidget({super.key, required this.ship, required this.tileSize, required this.waveAnim});

  // optimizations
  late final position = toIsometric(ship.getPosition(globalScale));
  late final orientation = ship.getDirection();
  late final shipScale = tileSize * 4;
  late final double waveOffset = (position.x + position.y) / -3;

  @override
  Widget build(BuildContext context) =>
      AnimatedBuilder(
          animation: waveAnim,
          child: ShipView(
            scale: shipScale,
            direction: orientation,
          ),
          builder: (context, child) =>
              Transform.translate(
                  offset: Offset(
                      position.x,
                      position.y + sin(waveAnim.value + waveOffset) * tileSize / 4
                  ),
                  child: child
              )
      );
}