import 'dart:async';

import 'package:ship_conquest/providers/game/global_controllers/minimap_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/scene_controller.dart';
import 'package:ship_conquest/utils/constants.dart';

import '../../domain/immutable_collections/sequence.dart';
import '../../services/ship_services/ship_services.dart';
import 'global_controllers/schedule_controller.dart';
import 'global_controllers/ship_controller.dart';
import 'global_controllers/statistics_controller.dart';

///
/// GameController class is in charge of the game state and
/// holding all the independent game piece providers together
///
/// Also in charge of:
///   - loading initial data;
///   - schedule server requests;
///   - subscribing to server notifications;
///   - schedule app notification.
///
/// Lazy-loaded so it's only created when used, which means,
/// only after a game is created.
class GameController {
  final ShipController shipController;
  final StatisticsController statisticsController;
  final SceneController sceneController;
  final MinimapController minimapController;
  final ShipServices services;
  final ScheduleController scheduleController;
  // constructor
  GameController({
    required this.shipController,
    required this.statisticsController,
    required this.sceneController,
    required this.minimapController,
    required this.services,
    required this.scheduleController
});

  Future<void> load() async { // load initial data
    scheduleController.stop();

    // fetch player fleet of ships
    shipController.setFleet(await services.getUserShips());
    // TODO: schedule events from loaded ships & on navigate
    // fetch player statistics
    statisticsController.updateStatistics(await services.getPlayerStatistics());
    // load visited islands & get scene for current ship
    sceneController.load(Sequence.empty());
    final position = shipController.getMainShip().getPosition(globalScale);
    sceneController.getScene(position, services);
    // fetch player minimap
    minimapController.load(await services.getMinimap());

    // schedule game update every 2 seconds
    scheduleController.schedule(update, const Duration(seconds: 2));
  }

  Future<void> update() async {
    // get scene for current ship
    final position = shipController.getMainShip().getPosition(globalScale);
    final tiles = await sceneController.getScene(position, services);
    // add scene to minimap
    minimapController.update(tiles);
  }
}