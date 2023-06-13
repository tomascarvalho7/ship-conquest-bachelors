import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/either/future_either.dart';
import 'package:ship_conquest/domain/island/utils.dart';
import 'package:ship_conquest/providers/feedback_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/scene_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/ship_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/statistics_controller.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';

import '../../../domain/island/island.dart';
import '../../../domain/isometric/isometric.dart';
import '../../camera_controller.dart';
import '../../../utils/constants.dart';

/// GameEvent static class calls game business logic
/// using the Game related providers to execute game
/// events from the player's actions.
///
/// These providers are built like independent pieces
/// and the GameEvent class combines and uses them together.
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
    final sceneController = context.read<SceneController>();
    final shipController = context.read<ShipController>();
    // select ship
    shipController.selectShip(index);
    // set camera focus to selected ship
    final ship = shipController.getMainShip();
    final shipPosition = ship.getPosition(-globalScale);
    sceneController.getScene(shipPosition, ship.sid);
    cameraController.setFocusAndUpdate(toIsometric(shipPosition));
  }

  static void conquestIsland(BuildContext context, Island island) async {
    // get controllers
    final services = context.read<ShipServices>();
    final sceneController = context.read<SceneController>();
    final statisticsController = context.read<StatisticsController>();
    final feedbackController = context.read<FeedbackController>();
    // server request to conquest island, and then update current scene
    services.conquestIsland(1, island.id).either(
        (left) => feedbackController.setError(left),
        (right) {
          statisticsController.makeTransaction(island.conquestCost());
          sceneController.updateIsland(right);
        }
    );
  }

  static void purchaseShip(BuildContext context) async {
    // get controllers
    final shipController = context.read<ShipController>();
    final services = context.read<ShipServices>();
    final feedbackController = context.read<FeedbackController>();
    final statisticsController = context.read<StatisticsController>();
    // handle ship creation
    services.createNewShip().either(
            (left) => feedbackController.setError(left),
            (right) {
              shipController.updateFleet(right);
              statisticsController.makeTransaction(-shipCost);
            }
    );
  }
}