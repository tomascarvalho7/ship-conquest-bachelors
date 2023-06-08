import 'dart:async';

import 'package:ship_conquest/config/notification/custom_notifications.dart';
import 'package:ship_conquest/config/notification/notification_service.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/providers/game/game_logic.dart';
import 'package:ship_conquest/providers/game/global_controllers/minimap_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/scene_controller.dart';
import 'package:ship_conquest/utils/constants.dart';

import '../../domain/event/known_event.dart';
import '../../domain/event/unknown_event.dart';
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

  late final gameLogic = GameLogic(
      shipController: shipController,
      statisticsController: statisticsController,
      sceneController: sceneController,
      minimapController: minimapController,
      services: services,
      scheduleController: scheduleController
  );

  Future<void> load() async { // load initial data
    // remove previous events
    scheduleController.stop();
    // initialize notifications
    NotificationService.initialize();
    final ships = await gameLogic.loadData();
    // schedule ship events
    scheduleShipEvents(ships);
    // subscribe to game events
    services.subscribe(gameLogic.onEvent, gameLogic.onFleet);
  }

  void exit() async {
    // remove previous events
    scheduleController.stop();
    // unsubscribe to game events
    services.unsubscribe();
  }

  void scheduleShipEvents(Sequence<Ship> ships) {
    for (var ship in ships) {
      scheduleShipEvent(ship);
    }
  }

  void scheduleShipEvent(Ship ship) {
    for(var event in ship.futureEvents.toSequence()) {
      buildEventNotification(event);
      scheduleController.scheduleEvent(event.eid, event.duration,
              () => gameLogic.discoverEvent(event.eid, ship.sid)
      );
    }
  }

  void deleteShipEvent(Ship ship) {
    for(var event in ship.futureEvents.toSequence()) {
      NotificationService.removeNotification(event.eid);
      scheduleController.cancelEvent(event.eid);
    }
  }
}