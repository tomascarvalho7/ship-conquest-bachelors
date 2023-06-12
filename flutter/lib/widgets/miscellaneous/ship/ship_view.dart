

import 'package:flutter/cupertino.dart';
import '../../../domain/ship/utils/classes/direction.dart';

class ShipView extends StatelessWidget {
  final double scale;
  final Direction direction;
  final bool isFighting;
  // constructor
  const ShipView({super.key, required this.scale, required this.direction, required this.isFighting});

  @override
  Widget build(BuildContext context) => switch(isFighting) {
    false => ship(),
    true => target(ship())
  };

  Widget target(Widget child) => Stack(
    children: [
      Image.asset(
        'assets/images/target.png',
        width: scale,
        height: scale,
      ),
      child
    ],
  );

  Widget ship() => Image.asset(
    _getShipAsset(),
    width: scale,
    height: scale,
  );

  String _getShipAsset() => switch(direction) {
    Direction.up => 'assets/images/ship_up.png',
    Direction.left => 'assets/images/ship_left.png',
    Direction.down => 'assets/images/ship_down.png',
    Direction.right => 'assets/images/ship_right.png'
  };
}