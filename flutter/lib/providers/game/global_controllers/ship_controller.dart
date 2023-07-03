import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/immutable_collections/grid.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/immutable_collections/utils/extend_grid.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/domain/space/position.dart';


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

  /// Retrieves the main ship, meaning the one selected.
  ///
  /// If the ship was moving and reached the destiny, retrieves a StaticShip.
  Ship getMainShip() {
    Ship ship = ships.get(shipIds.get(selectedShip));
    if (ship is MobileShip && ship.path.hasReachedDestiny()) {
      return StaticShip(
          sid: ship.sid,
          coordinate: ship.path.getPosition(ship.path.landmarks.length * 1.0).toCoord2D(),
          completedEvents: ship.completedEvents,
          futureEvents: ship.futureEvents
      );
    }

    return ship;
  }

  /// Retrieves the id of the selected ship.
  int getMainShipId() => shipIds.get(selectedShip);

  /// Retrieves the [Ship] with the given [index].
  Ship getShip(int index) => ships.get(shipIds.get(index));

  /// Sets a new [fleet].
  void setFleet(Sequence<Ship> fleet) {
    ships = Grid(
        data: { for (var ship in fleet) ship.sid : ship }
    );
    shipIds = Sequence(data: fleet.map((ship) => ship.sid).data);
  }

  /// Simply notifies the listeners to force the fighting sate update.
  void updateFightState() {
    // simply update widgets
    print("update");
    notifyListeners();
  }

  /// Updates the fleet by adding [ship].
  void updateFleet(Ship ship) {
    ships = ships.put(ship.sid, ship);
    shipIds = shipIds.put(ship.sid);
    notifyListeners();
  }

  /// Updates a [ship] with new data.
  void updateShip(Ship ship) {
    ships = ships.put(ship.sid, ship);
    notifyListeners();
  }

  /// Changes the selected ship to the one at the given [index].
  void selectShip(int index) {
    selectedShip = index;
    notifyListeners();
  }

  /// Updates the status of every ship in the fleet.
  void updateFleetStatus() {
    ships = ships.map((ship) => _updateShipStatus(ship));
  }

  /// Retrieves the positions of each ship present in the fleet.
  Sequence<Position> getShipPositions(double scale) =>
      ships.toSequence().map((ship) => ship.getPosition(scale));

  /// Updates the fleet status and applies the function [block] to every ship in the fleet.
  ///
  /// Returns a list with the new data.
  List<T> buildListFromShips<T>(T Function(Ship ship) block) {
    updateFleetStatus();

    return ships.toSequence().map(block).data;
  }

  /// Updates the ship status.
  ///
  /// If the ship was moving and reached the destiny, update it to a [StaticShip].
  Ship _updateShipStatus(Ship ship) {
    if (ship is MobileShip && ship.path.hasReachedDestiny()) {
      return StaticShip(
          sid: ship.sid,
          coordinate: ship.path.getPositionFromTime().toCoord2D(),
          completedEvents: ship.completedEvents,
          futureEvents: ship.futureEvents
      );
    }

    return ship;
  }
}