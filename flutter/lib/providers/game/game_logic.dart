import 'package:ship_conquest/config/notification/notification_service.dart';
import 'package:ship_conquest/domain/either/future_either.dart';
import 'package:ship_conquest/domain/event/unknown_event.dart';
import 'package:ship_conquest/domain/feedback/error/error_feedback.dart';
import 'package:ship_conquest/domain/feedback/success/utils/constants.dart';
import 'package:ship_conquest/domain/feedback/success/utils/functions.dart';
import 'package:ship_conquest/domain/game/horizon.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';
import 'package:ship_conquest/providers/game/global_controllers/minimap_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/scene_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/ship_controller.dart';

import '../../domain/event/known_event.dart';
import '../../domain/immutable_collections/sequence.dart';
import '../../domain/island/island.dart';
import '../../domain/ship/ship.dart';
import '../../services/ship_services/ship_services.dart';
import '../../utils/constants.dart';
import '../feedback_controller.dart';
import 'global_controllers/schedule_controller.dart';
import 'global_controllers/statistics_controller.dart';

///
/// The [GameLogic] class holds all the game related
/// business logic.
///
class GameLogic {
  final ShipController shipController;
  final StatisticsController statisticsController;
  final SceneController sceneController;
  final MinimapController minimapController;
  final ShipServices services;
  final ScheduleController scheduleController;
  final FeedbackController feedbackController;
  // constructor
  GameLogic({
    required this.shipController,
    required this.statisticsController,
    required this.sceneController,
    required this.minimapController,
    required this.services,
    required this.scheduleController,
    required this.feedbackController
  });

  /// load game initial data
  Future loadData(Function(Sequence<Ship>) scheduleShipEvents) async {
    // fetch player fleet of ships & schedule they're events
    await _handleServiceMethod(services.getUserShips(), (ships) {
      shipController.setFleet(ships); // set fleet
      scheduleShipEvents(ships); // schedule ship events
    });

    // fetch player statistics
    await _handleServiceMethod(services.getPlayerStatistics(), (statistics) =>
      statisticsController.updateStatistics(statistics)
    );

    // load visited islands & get scene for current ship
    await _handleServiceMethod(services.getVisitedIslands(), (islands) =>
      sceneController.load(islands, _getHorizon)
    );

    // fetch player minimap
    await _handleServiceMethod(services.getMinimap(), (minimap) =>
        minimapController.load(minimap)
    );

    final mainShip = shipController.getMainShip();
    final position = mainShip.getPosition(globalScale);
    final tiles = await sceneController.getScene(position, mainShip.sid);
    minimapController.update(tiles);

    // schedule game update every 2 seconds
    scheduleController.scheduleJob(const Duration(seconds: 2), update);
  }

  /// callback function to run when the server-sent-events send a [UnknownEvent]
  void onEvent(int sid, UnknownEvent event) {
    scheduleController.scheduleEvent(event.eid, event.duration,
        () => discoverEvent(event.eid, sid)
    );
  }

  /// callback function to run when the server-sent-events send a [Fleet]
  void onFleet(Sequence<Ship> fleet) {
    shipController.setFleet(fleet);
  }

  /// periodic function to update the game data
  Future<void> update() async {
    final mainShip = shipController.getMainShip();
    final position = mainShip.getPosition(globalScale);
    final tiles = await sceneController.tryToGetScene(position, mainShip.sid);
    // add scene to minimap
    minimapController.update(tiles);
  }

  /// callback function to run when a [UnknownEvent] is fetched
  void discoverEvent(int eid, int sid) async =>
    _handleServiceMethod(services.getShip(sid), (ship) {
      shipController.updateShip(ship);
      final event = ship.completedEvents.get(eid);
      if (event is IslandEvent) handleIsland(ship, event.island);
      if (event is FightEvent) handleFight(ship, event);
    });

  /// callback function to run on a [IslandEvent]
  void handleIsland(Ship ship, Island island) {
    feedbackController.setSuccessful(islandFound);
    NotificationService.removeNotification(ship.sid);
    sceneController.discoverIsland(island);
    getScene(ship);
  }

  /// callback function to run on a [FightEvent]
  /// schedule to update the ship state to fighting
  void handleFight(Ship ship, FightEvent event) {
    shipController.updateFightState(); // update fight state
    feedbackController.setSuccessful(fighting); // give feedback to user
    scheduleController.scheduleEvent(event.eid, fightDuration,
            () { // schedule to update fight state after fight is finished
            shipController.updateFightState();
            feedbackController.setSuccessful(fightResult(event.won));
      }
    );
  }

  /// force fetch to get the scene from the back-end data
  void getScene(Ship ship) async {
    // get scene for current ship
    final position = ship.getPosition(globalScale);
    final tiles = await sceneController.getScene(position, ship.sid);
    // add scene to minimap
    minimapController.update(tiles);
  }

  /// callback function to fetch scene from the back-end data
  Future<Horizon?> _getHorizon(Coord2D coord, int sid) async {
    final res = await services.getNewChunk(chunkSize, coord, sid);
    if (res.isLeft) feedbackController.setError(res.left);
    return res.isRight ? res.right : null;
  }

  /// utility function to handle methods from the [ShipServices] class.
  /// The result from this method's can either be:
  /// - [ErrorFeedback] and in this case the user is notified;
  /// - [SuccessFeedback] and in this case the [onSuccess] method is
  /// executed.
  Future _handleServiceMethod<T>(
      FutureEither<ErrorFeedback, T> result,
      Function(T res) onSuccess
    ) =>
    result.either(
      (error) => feedbackController.setError(error),
      (success) => onSuccess(success)
    );
}

