import 'package:ship_conquest/providers/game/global_controllers/minimap_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/scene_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/ship_controller.dart';

import '../../domain/event/known_event.dart';
import '../../domain/island/island.dart';
import '../../domain/ship/ship.dart';
import '../../services/ship_services/ship_services.dart';
import '../../utils/constants.dart';
import 'global_controllers/schedule_controller.dart';
import 'global_controllers/statistics_controller.dart';

class GameLogic {
  final ShipController shipController;
  final StatisticsController statisticsController;
  final SceneController sceneController;
  final MinimapController minimapController;
  final ShipServices services;
  final ScheduleController scheduleController;
  // constructor
  GameLogic({
    required this.shipController,
    required this.statisticsController,
    required this.sceneController,
    required this.minimapController,
    required this.services,
    required this.scheduleController
  });

  Future<void> update() async {
    final ship = shipController.getMainShip();
    // get scene for current ship
    final position = ship.getPosition(globalScale);
    final tiles = await sceneController.getScene(position, services, ship.sid);
    // add scene to minimap
    minimapController.update(tiles);
  }

  void discoverEvent(int eid, int sid) async {
    final newShip = await services.getShip(sid);
    if (newShip == null) return;

    shipController.updateShip(newShip);
    final event = newShip.completedEvents.get(eid);
    if (event is IslandEvent) discoverIsland(newShip, event.island);
    if (event is FightEvent) print('fighting!');
  }

  void discoverIsland(Ship ship, Island island) {
    sceneController.discoverIsland(island);
    getScene(ship);
  }

  void getScene(Ship ship) async {
    // get scene for current ship
    final position = ship.getPosition(globalScale);
    final tiles = await sceneController.getScene(position, services, ship.sid);
    // add scene to minimap
    minimapController.update(tiles);
  }
}

