import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/game/global_controllers/scene_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/ship_controller.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';

import '../../../domain/island/island.dart';
import '../../../domain/isometric/isometric.dart';
import '../../camera_controller.dart';
import '../../../utils/constants.dart';

/// GameEvent static class calls game business logic
/// using the Game related providers.
///
/// These providers are built like independent pieces
/// and the GameEvent class combines them to implement
/// the different game events.
class GameEvent {
  const GameEvent();

  // load initial data
  static void load(BuildContext context) {
    // get controller
    final cameraController = context.read<CameraController>();
    final shipController = context.read<ShipController>();
    // set camera focus to main ship
    cameraController.setFocus(toIsometric(shipController.getMainShip().getPosition(-globalScale)));
  }

  static void selectShip(BuildContext context, int index) async {
    // get controller
    final cameraController = context.read<CameraController>();
    final services = context.read<ShipServices>();
    final sceneController = context.read<SceneController>();
    final shipController = context.read<ShipController>();
    // select ship
    shipController.selectShip(index);
    // set camera focus to selected ship
    final ship = shipController.getMainShip();
    final shipPosition = ship.getPosition(-globalScale);
    cameraController.setFocusAndUpdate(toIsometric(shipPosition));
    // update scene
    sceneController.getScene(shipPosition, services, ship.sid);
  }

  static void conquestIsland(BuildContext context, Island island) async {
    // get controller
    final services = context.read<ShipServices>();
    final sceneController = context.read<SceneController>();
    // server request to conquest island, and then update current scene
    final newIsland = await services.conquestIsland(1, island.id);
    sceneController.updateIsland(newIsland);
  }
}