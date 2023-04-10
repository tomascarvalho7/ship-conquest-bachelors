
import 'package:ship_conquest/domain/space/position.dart';
import 'package:ship_conquest/domain/token.dart';
import 'package:ship_conquest/providers/ship_manager.dart';
import 'package:ship_conquest/providers/tile_manager.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';

import '../providers/camera.dart';
import '../providers/minimap_provider.dart';
import 'color/color_gradient.dart';

/// GameEvent class contains game business logic
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
  final ColorGradient colorGradient;
  // constructor
  GameEvent({
    required this.camera,
    required this.tileManager,
    required this.shipManager,
    required this.minimapProvider,
    required this.colorGradient
  });

  // load initial data
  void load(ShipServices services)  {
    // set camera focus to main ship
    camera.setFocus(shipManager.getMainShip().getPosition());
    // fetch minimap
    services.getMinimap(Token(token: 'TODO'), colorGradient).then(
            (minimap) {
              minimapProvider.init(minimap);
              lookAround(services);
            }
    );
  }

  // look around for new tiles
  void lookAround(ShipServices services) async {
    List<Position> shipPositions = shipManager.getShipPositions();

    for(var shipPosition in shipPositions) {
      bool looked = await tileManager.lookForTiles(shipPosition, services);
      // if new tiles were found, add them to minimap
      if (looked) {
        minimapProvider.update(tileManager.tiles, colorGradient);
      }
    }
  }
}