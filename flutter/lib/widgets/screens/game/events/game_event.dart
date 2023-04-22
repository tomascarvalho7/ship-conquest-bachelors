import 'package:ship_conquest/domain/game_data.dart';
import 'package:ship_conquest/domain/space/position.dart';
import 'package:ship_conquest/providers/ship_manager.dart';
import 'package:ship_conquest/providers/tile_manager.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';

import '../../../../domain/isometric/isometric.dart';
import '../../../../providers/camera.dart';
import '../../../../providers/global_state.dart';
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
  final GlobalState state;
  final Camera camera;
  final TileManager tileManager;
  final ShipManager shipManager;
  final MinimapProvider minimapProvider;
  final ShipServices services;
  final ColorGradient colorGradient;
  // constructor
  GameEvent({
    required this.state,
    required this.camera,
    required this.tileManager,
    required this.shipManager,
    required this.minimapProvider,
    required this.services,
    required this.colorGradient
  });

  // save game data
  void saveGameData() {
    state.updateGameData(
      GameData(
          minimap: minimapProvider.minimap,
          ships: shipManager.ships
      )
    );
    state.updateCameraState(camera.coordinates, camera.scaleFactor);
  }

  // load initial data
  void load() {
    final lastStatePos = state.cameraPos;
    final lastStateScale = state.cameraScale;
    if (lastStatePos != null && lastStateScale != null) {
      // set camera focus to previous position
      camera.setFocus(lastStatePos, scale: lastStateScale);
    } else {
      // set camera focus to main ship
      camera.setFocus(toIsometric(shipManager.getMainShip().getPosition(-globalScale)));
    }
    // look around !
    lookAround();
  }

  // look around for new tiles
  void lookAround() {
    List<Position> shipPositions = shipManager.getShipPositions(globalScale);

    for(var shipPosition in shipPositions) {
      // add new tiles near every ship to minimap
      tileManager.lookForTiles(shipPosition, services).then(
              (tiles) => minimapProvider.update(tiles, colorGradient)
      );
    }
  }
}