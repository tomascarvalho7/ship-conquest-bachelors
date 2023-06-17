import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/either/future_either.dart';
import 'package:ship_conquest/domain/island/island.dart';
import 'package:ship_conquest/domain/island/utils.dart';
import 'package:ship_conquest/domain/isometric/isometric.dart';
import 'package:ship_conquest/providers/camera_controller.dart';
import 'package:ship_conquest/providers/feedback_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/scene_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/ship_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/statistics_controller.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';
import 'package:ship_conquest/utils/constants.dart';


/// GameEvent static class calls game business logic
/// using the Game related providers to execute game
/// events from the player's actions.
///
/// These providers are built like independent pieces
/// and the GameEvent class combines and uses them together.
class GameEvent {
  const GameEvent();

  /// Load initial data.
  static void load(BuildContext context) {
    // get controller
    final cameraController = context.read<CameraController>();
    final shipController = context.read<ShipController>();
    // set camera focus to main ship
    cameraController.setFocus(toIsometric(shipController.getMainShip().getPosition(-globalScale)));
  }

  /// Select a ship at a given [index].
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

  /// Conquest an [island].
  static void conquestIsland(BuildContext context, Island island) async {
    // get controllers
    final services = context.read<ShipServices>();
    final sceneController = context.read<SceneController>();
    final shipController = context.read<ShipController>();
    final statisticsController = context.read<StatisticsController>();
    final feedbackController = context.read<FeedbackController>();
    // server request to conquest island, and then update current scene
    services.conquestIsland(shipController.getMainShipId(), island.id).either(
        (left) => feedbackController.setError(left),
        (right) {
          statisticsController.makeTransaction(-island.conquestCost());
          sceneController.updateIsland(right);
        }
    );
  }

  /// Purchase a new ship.
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