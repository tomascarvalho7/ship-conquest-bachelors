import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/ship/ship_path.dart';
import 'package:ship_conquest/domain/space/position.dart';
import '../domain/ship/dynamic_ship.dart';
import '../domain/ship/ship.dart';

///
/// Provider handling Ship info
/// IMPORTANT: The number of ships must be always greater than 1
///
class ShipManager with ChangeNotifier {
  final List<Ship> ships;
  // constructor
  ShipManager({required this.ships});

  Ship getMainShip() => ships[0];

  void setSail(int sId, ShipPath path) {
    ships[sId] = DynamicShip(path: path);
    notifyListeners();
  }

  List<Position> getShipPositions(double scale) {
    return ships.map((e) => e.getPosition(scale)).toList();
  }

  List<T> buildListFromShips<T>(T Function(Ship ship) block) =>
    List.generate(ships.length, (index) => block(ships[index]));
}