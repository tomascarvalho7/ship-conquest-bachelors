import 'package:ship_conquest/domain/ship/ship_path.dart';
import 'package:ship_conquest/providers/minimap_provider.dart';
import 'package:ship_conquest/providers/route_manager.dart';
import 'package:ship_conquest/providers/ship_manager.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';

import '../../../../domain/space/coord_2d.dart';
import '../../../../domain/space/position.dart';
import '../../../../providers/camera.dart';
import '../../../../utils/constants.dart';

/// MinimapEvent class calls minimap business logic
/// using the Minimap related providers.
///
/// These providers are built like independent pieces
/// and the MinimapEvent class combines them to implement
/// the different minimap events & interactions.
class MinimapEvent {
  final Camera camera;
  final MinimapProvider minimap;
  final RouteManager route;
  final ShipManager shipManager;
  final ShipServices services;
  // constructor
  MinimapEvent({required this.camera, required this.minimap, required this.route, required this.shipManager, required this.services});

  double get scale => minimapSize / minimap.minimap.length;

  void load() {
    camera.setFocus(shipManager.getMainShip().getPosition(-scale));
  }

  void setup() {
    route.setupHooks(shipManager.getShipPositions(scale), minimap.minimap);
  }

  // move control node
  void moveNode(Position delta) {
    route.moveNode(minimap.minimap, delta);
  }

  // confirm route
  void confirm() async {
    final beziers = route.beziers;
    if (beziers != null) {
      final landmarks = beziers
          .map((e) => Coord2D(
            x: (e.x / scale).round(),
            y: (e.y / scale).round())
          )
          .toList();
      ShipPath path = await services.navigateTo(0, landmarks);
      shipManager.setSail(0, path);
    }
    route.confirm();
  }

  // cancel route
  void cancel() {
    route.cancel();
  }
}