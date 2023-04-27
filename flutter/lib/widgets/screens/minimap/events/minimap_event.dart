import 'package:ship_conquest/domain/game_data.dart';
import 'package:ship_conquest/domain/path_builder/path_builder.dart';
import 'package:ship_conquest/domain/ship/ship_path.dart';
import 'package:ship_conquest/providers/minimap_provider.dart';
import 'package:ship_conquest/providers/route_manager.dart';
import 'package:ship_conquest/providers/ship_manager.dart';
import 'package:ship_conquest/providers/tile_manager.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';

import '../../../../domain/space/coord_2d.dart';
import '../../../../domain/space/position.dart';
import '../../../../providers/camera.dart';
import '../../../../providers/global_state.dart';
import '../../../../utils/constants.dart';

/// MinimapEvent class calls minimap business logic
/// using the Minimap related providers.
///
/// These providers are built like independent pieces
/// and the MinimapEvent class combines them to implement
/// the different minimap events & interactions.
class MinimapEvent {
  final GlobalState state;
  final Camera camera;
  final MinimapProvider minimap;
  final RouteManager route;
  final ShipManager shipManager;
  final TileManager tileManager;
  final ShipServices services;
  // constructor
  MinimapEvent({required this.state, required this.camera, required this.minimap, required this.route, required this.shipManager, required this.tileManager, required this.services});

  double get scale => minimapSize / minimap.minimap.length;
  double get invScale => minimap.minimap.length / minimapSize;

  void saveGameData() {
    state.updateGameData(
      GameData(
          minimap: minimap.minimap,
          ships: shipManager.ships
      )
    );
  }

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

  void deselectAndBuildPath() {
    final points = route.pathPoints;
    if (points != null) {
      // invert scale on coord2D function
      invertScale(Position pos) => Coord2D(x: (pos.x * invScale).round(), y: (pos.y * invScale).round());

      final path = PathBuilder.build(
          minimap.minimap,
          invertScale(points.start),
          invertScale(points.mid),
          invertScale(points.end),
          10,
          3,
          500
      );
      route.setRoutePoints(PathBuilder.normalize(path, 2));
      route.deselect();
    }
  }

  // confirm route
  void confirm() async {
    final landmarks = route.routePoints;
    if (landmarks.isNotEmpty) {
      ShipPath path = await services.navigateTo(0, landmarks);
      shipManager.setSail(0, path);
    }
    route.confirm();
  }

  // cancel route
  void cancel() {
    route.cancel();
  }

  // look around for new tiles
  void lookAround() {
    List<Position> shipPositions = shipManager.getShipPositions(globalScale);

    for(var shipPosition in shipPositions) {
      // add new tiles near every ship to minimap
      tileManager.lookForTiles(shipPosition, services).then(
              (tiles) => minimap.update(tiles, state.colorGradient)
      );
    }
  }
}