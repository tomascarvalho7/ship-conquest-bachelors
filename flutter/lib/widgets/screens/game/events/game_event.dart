import 'package:ship_conquest/domain/space/position.dart';
import 'package:ship_conquest/domain/token.dart';
import 'package:ship_conquest/providers/ship_manager.dart';
import 'package:ship_conquest/providers/tile_manager.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';

import '../../../../domain/isometric/isometric.dart';
import '../../../../providers/camera.dart';
import '../../../../providers/minimap_provider.dart';
import '../../../../domain/color/color_gradient.dart';
import '../../../../utils/constants.dart';

/// GameEvent class calls game business logic
/// using the Game related providers.
///
/// These providers are built like independent pieces
/// and the GameEvent class combines them to implement
/// the different game events.
class GameEvent {
  final Camera camera;
  final TileManager tileManager;
  final ShipManager shipManager;
  final MinimapProvider minimapProvider;
  final ShipServices services;
  final ColorGradient colorGradient;
  // constructor
  GameEvent({
    required this.camera,
    required this.tileManager,
    required this.shipManager,
    required this.minimapProvider,
    required this.services,
    required this.colorGradient
  });

  // load initial data
  void load() {
    // set camera focus to main ship
    camera.setFocus(toIsometric(shipManager.getMainShip().getPosition(-globalScale)));
    // fetch minimap
    services.getMinimap(colorGradient).then(
            (minimap) {
              minimapProvider.init(minimap);
              lookAround();
            }
    );
  }

  // look around for new tiles
  void lookAround() async {
    List<Position> shipPositions = shipManager.getShipPositions(globalScale);

    for(var shipPosition in shipPositions) {
      bool looked = await tileManager.lookForTiles(shipPosition, services);
      // if new tiles were found, add them to minimap
      if (looked) {
        minimapProvider.update(tileManager.tiles, colorGradient);
      }
    }
  }
}