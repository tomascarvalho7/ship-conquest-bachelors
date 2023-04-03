import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/space/position.dart';
import 'package:ship_conquest/main.dart';

import '../domain/ship.dart';

///
/// Provider handling Ship info
/// IMPORTANT: The number of ships must be always greater than 1
///
class ShipManager with ChangeNotifier {
  final List<Ship> ships;
  // constructor
  ShipManager({required this.ships});

  Ship getMainShip() => ships[0];

  List<Position> getShipPositions() {
    double x = 0;
    double y = 0;
    return [
      Position(
        x: (x - y) * tileSize / 2,
        y: (x + y) * tileSize / 4,
      )
    ];
  }

  List<T> buildListFromShips<T>(T Function(Ship ship) block) =>
    List.generate(ships.length, (index) => block(ships[index]));

}