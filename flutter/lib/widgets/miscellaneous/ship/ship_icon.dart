import 'package:flutter/material.dart';

import '../../../domain/ship.dart';
import '../../../domain/space/position.dart';

class ShipIcon extends StatelessWidget {
  final Ship ship;
  final Widget? child;
  ShipIcon({super.key, required this.ship, this.child});

  late final Position position = ship.getPosition();

  @override
  Widget build(BuildContext context) => // TODO !
    Transform.translate(
        offset: Offset(position.x, position.y),
        child: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            color: Colors.green,
            child: child
        )
    );
}