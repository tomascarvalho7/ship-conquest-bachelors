import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/path_builder/path_builder.dart';
import 'package:ship_conquest/providers/game/global_controllers/minimap_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/ship_controller.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';

import '../../../domain/immutable_collections/sequence.dart';
import '../../../domain/ship/ship.dart';
import '../../../domain/space/coord_2d.dart';
import '../../../domain/space/position.dart';
import '../../camera_controller.dart';
import '../../../utils/constants.dart';
import '../minimap_controllers/route_controller.dart';

/// MinimapEvent is a static class that calls minimap
/// business logic using the Minimap related providers.
///
/// These providers are built like independent pieces
/// and the MinimapEvent class combines them to implement
/// the different minimap events & interactions.
class MinimapEvent {
  const MinimapEvent();

  static void load(BuildContext context) {
    // get controllers
    final minimapController = context.read<MinimapController>();
    final cameraController = context.read<CameraController>();
    final shipController = context.read<ShipController>();
    final routeController = context.read<RouteController>();
    // set camera focus on main ship
    final scale = minimapSize / minimapController.minimap.length;
    cameraController.setFocus(shipController.getMainShip().getPosition(-scale));
    // setup route hooks
    routeController.setupHooks(shipController.getShipPositions(scale));
  }

  static void deselectAndBuildPath(BuildContext context) {
    // get controllers
    final routeController = context.read<RouteController>();
    final minimapController = context.read<MinimapController>();
    // deselect and build path from route points
    final points = routeController.pathPoints;
    final invScale = minimapController.minimap.length / minimapSize;
    if (points != null) {
      // invert scale on coord2D function
      invertScale(Position pos) => Coord2D(x: (pos.x * invScale).round(), y: (pos.y * invScale).round());

      final path = PathBuilder.build(
          minimapController.minimap,
          invertScale(points.start),
          invertScale(points.mid),
          invertScale(points.end),
          10,
          3,
          500
      );
      routeController.setRoutePoints(Sequence(data: PathBuilder.normalize(path, 2)));
      routeController.deselect();
    }
  }

  // confirm route
  static void confirm(BuildContext context) async {
    // get controllers
    final routeController = context.read<RouteController>();
    final services = context.read<ShipServices>();
    final shipController = context.read<ShipController>();
    final landmarks = routeController.routePoints;
    if (landmarks.length > 0) {
      final sId = shipController.getShip(routeController.selectedShipIndex).getSid();
      Ship ship = await services.navigateTo(sId, landmarks);
      shipController.setSail(ship);
    }
    routeController.confirm();
  }

  // cancel route
  static void cancel(BuildContext context) {
    // get controllers
    final routeController = context.read<RouteController>();
    routeController.cancel();
  }
}