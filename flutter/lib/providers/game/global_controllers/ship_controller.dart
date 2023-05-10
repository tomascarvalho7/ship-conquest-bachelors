import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/ship/static_ship.dart';
import 'package:ship_conquest/domain/space/position.dart';
import '../../../domain/immutable_collections/grid.dart';
import '../../../domain/immutable_collections/sequence.dart';
import '../../../domain/ship/mobile_ship.dart';
import '../../../domain/ship/ship.dart';

///
/// Provider handling Ship info
/// Assumes there is always at least one ship
///
class ShipController with ChangeNotifier {
  // constructor
  ShipController();

  // variables
  Grid<int, Ship> ships = Grid.empty();
  Sequence<int> shipIds = Sequence.empty();
  int selectedShip = 0;

  Ship getMainShip() => ships.get(shipIds.get(selectedShip));

  void setFleet(Sequence<Ship> fleet) {
    ships = Grid(
        data: { for (var ship in fleet.data) ship.getSid() : ship }
    );
    shipIds = Sequence(data: fleet.map((ship) => ship.getSid()).data);
  }

  void selectShip(int index) {
    selectedShip = index;
  }

  void setSail(Ship ship) {
    ships = ships.put(ship.getSid(), ship);
    notifyListeners();
  }

  void updateFleetStatus() {
    ships = ships.map((ship) => _updateShipStatus(ship));
  }

  Sequence<Position> getShipPositions(double scale) =>
      ships.toSequence().map((ship) => ship.getPosition(scale));

  List<T> buildListFromShips<T>(T Function(Ship ship) block) {
    updateFleetStatus();

    return ships.toSequence().map(block).data;
  }

  Ship _updateShipStatus(Ship ship) {
    if (ship is MobileShip && ship.path.hasReachedDestiny()) {
      return StaticShip(
          sid: ship.sid,
          coordinate: ship.path.getPositionFromTime().toCoord2D(),
      );
    }

    return ship;
  }
}