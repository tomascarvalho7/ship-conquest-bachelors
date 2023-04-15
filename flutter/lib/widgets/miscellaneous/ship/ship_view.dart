

import 'package:flutter/cupertino.dart';
import '../../../domain/ship/direction.dart';

class ShipView extends StatelessWidget {
  final double scale;
  final Direction direction;
  // constructor
  const ShipView({super.key, required this.scale, required this.direction});

  @override
  Widget build(BuildContext context) =>
    Transform.translate(
        offset: Offset(-scale / 2, -scale / 2),
        child: getShipDirection()
    );

    Widget getShipDirection() {
      if (direction == Direction.up) {
        return Image.asset(
          'assets/images/ship_up.png',
          width: scale,
          height: scale,
        );
      } else if (direction == Direction.left) {
        return Image.asset(
          'assets/images/ship_left.png',
          width: scale,
          height: scale,
        );
      } else if (direction == Direction.down) {
        return Image.asset(
          'assets/images/ship_down.png',
          width: scale,
          height: scale,
        );
      } else {
        return Image.asset(
          'assets/images/ship_right.png',
          width: scale,
          height: scale,
        );
    }
  }
}