import 'package:ship_conquest/domain/either/future_either.dart';
import 'package:ship_conquest/domain/event/unknown_event.dart';
import 'package:ship_conquest/domain/feedback/error/error_feedback.dart';
import 'package:ship_conquest/domain/horizon.dart';
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

  Future loadData(Function(Sequence<Ship>) scheduleShipEvents) async {
    // fetch player fleet of ships & schedule they're events
    _handleServiceMethod(services.getUserShips(), (ships) {
      shipController.setFleet(ships); // set fleet
      scheduleShipEvents(ships); // schedule ship events
    });

    // fetch player statistics
    _handleServiceMethod(services.getPlayerStatistics(), (statistics) =>
      statisticsController.updateStatistics(statistics)
    );

    // load visited islands & get scene for current ship
    _handleServiceMethod(services.getVisitedIslands(), (islands) =>
      sceneController.load(islands)
    );

    final mainShip = shipController.getMainShip();
    final position = mainShip.getPosition(globalScale);
    await sceneController.getScene(position, (coord) =>
        _getHorizon(coord, mainShip.sid)
    );
    // fetch player minimap
    _handleServiceMethod(services.getMinimap(), (minimap) =>
        minimapController.load(minimap)
    );

    // schedule game update every 2 seconds
    scheduleController.scheduleJob(const Duration(seconds: 2), update);
  }

  void onEvent(int sid, UnknownEvent event) {
    print("SSE sent an event");
    scheduleController.scheduleEvent(event.eid, event.duration,
        () => discoverEvent(event.eid, sid)
    );
  }

  void onFleet(Sequence<Ship> fleet) {
    print("SSE sent an event");
    shipController.setFleet(fleet);
  }

  Future<void> update() async {
    for(var ship in shipController.ships.toSequence()) {
      // get scene for current ship
      final position = ship.getPosition(globalScale);
      final tiles = await sceneController.getScene(position, (coord) =>
          _getHorizon(coord, ship.sid)
      );
      // add scene to minimap
      minimapController.update(tiles);
    }
  }

  void discoverEvent(int eid, int sid) async =>
    _handleServiceMethod(services.getShip(sid), (ship) {
      shipController.updateShip(ship);
      final event = ship.completedEvents.get(eid);
      if (event is IslandEvent) discoverIsland(ship, event.island);
      if (event is FightEvent) print('fighting!');
    });

  void discoverIsland(Ship ship, Island island) {
    sceneController.discoverIsland(island);
    getScene(ship);
  }

  void getScene(Ship ship) async {
    // get scene for current ship
    final position = ship.getPosition(globalScale);
    final tiles = await sceneController.getScene(position, (coord) =>
      _getHorizon(coord, ship.sid)
    );
    // add scene to minimap
    minimapController.update(tiles);
  }

  Future<Horizon?> _getHorizon(Coord2D coord, int sid) async {
    final res = await services.getNewChunk(chunkSize, coord, sid);
    if (res.isLeft) feedbackController.setError(res.left);
    return res.isRight ? res.right : null;
  }

  void _handleServiceMethod<T>(
      FutureEither<ErrorFeedback, T> result,
      Function(T res) onSuccess
    ) =>
    result.either(
      (error) => feedbackController.setError(error),
      (success) => onSuccess(success)
    );
}

