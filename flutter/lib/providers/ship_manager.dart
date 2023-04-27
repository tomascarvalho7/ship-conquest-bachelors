import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/ship/ship_path.dart';
import 'package:ship_conquest/domain/ship/static_ship.dart';
import 'package:ship_conquest/domain/space/position.dart';
import 'package:ship_conquest/domain/space/sequence.dart';
import '../domain/ship/dynamic_ship.dart';
import '../domain/ship/ship.dart';

///
/// Provider handling Ship info
/// IMPORTANT: The number of ships must be always greater than 1
///
class ShipManager with ChangeNotifier {
  Sequence<Ship> ships;
  // constructor
  ShipManager({required this.ships});

  Ship getMainShip() => ships.get(0);

  void setSail(int sid, ShipPath path) {
    ships = ships.replace(sid, DynamicShip(path: path));
    notifyListeners();
  }

  List<Position> getShipPositions(double scale) =>
      ships.map((e) => e.getPosition(scale)).data;

  List<T> buildListFromShips<T>(T Function(Ship ship) block) {
    updateFleetStatus();

    return List.generate(
        ships.length,
            (index) => block(ships.get(index))
    );
  }

  void updateFleetStatus() {
    ships = ships.map((ship) => _updateShipStatus(ship));
  }

  Ship _updateShipStatus(Ship ship) {
    if (ship is DynamicShip && ship.path.hasReachedDestiny()) {
      return StaticShip(
          position: ship.path.getPositionFromTime(),
          orientation: ship.getOrientation()
      );
    }

    return ship;
  }
}