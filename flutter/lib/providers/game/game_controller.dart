import 'package:ship_conquest/config/notification/custom_notifications.dart';
import 'package:ship_conquest/config/notification/notification_service.dart';
import 'package:ship_conquest/domain/either/either.dart';
import 'package:ship_conquest/domain/either/future_either.dart';
import 'package:ship_conquest/domain/event/known_event.dart';
import 'package:ship_conquest/domain/feedback/error/error_feedback.dart';
import 'package:ship_conquest/domain/feedback/success/success_feedback.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/immutable_collections/utils/extend_grid.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/domain/ship/utils/logic.dart';
import 'package:ship_conquest/providers/feedback_controller.dart';
import 'package:ship_conquest/providers/game/game_logic.dart';
import 'package:ship_conquest/providers/game/global_controllers/minimap_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/scene_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/schedule_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/ship_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/statistics_controller.dart';
import 'package:ship_conquest/providers/sound_controller.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';


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
  final FeedbackController feedbackController;
  final SoundController soundController;
  // constructor
  GameController({
    required this.shipController,
    required this.statisticsController,
    required this.sceneController,
    required this.minimapController,
    required this.services,
    required this.scheduleController,
    required this.feedbackController,
    required this.soundController
});

  /// Instantiates [GameLogic] with all the needed controllers.
  late final gameLogic = GameLogic(
      shipController: shipController,
      statisticsController: statisticsController,
      sceneController: sceneController,
      minimapController: minimapController,
      services: services,
      scheduleController: scheduleController,
      feedbackController: feedbackController
  );

  /// Handles all the initial loading of the game.
  FutureEither<ErrorFeedback, SuccessFeedback> load() async { // load initial data
    // remove previous events
    scheduleController.stop();
    // initialize notifications
    NotificationService.initialize();
    await gameLogic.loadData(scheduleShipEvents);
    // check if any operation had an error
    final feedback = feedbackController.feedback;
    // play game background music
    soundController.startBackgroundMusic();

    if(feedback == null) {
      // subscribe to game events
      services.subscribe(gameLogic.onEvent, gameLogic.onFleet);
      return const Right(
          SuccessFeedback(
              title: "Success",
              details: "Successful operation"
          )
      );
    }

    return feedback;
  }

  /// Handles the action of leaving the game by stopping some running actions.
  void exit() async {
    // remove previous events
    scheduleController.stop();
    // unsubscribe to game events
    services.unsubscribe();
    // stop game background music
    soundController.stopAudio();
  }

  /// Schedules events for all [ships].
  void scheduleShipEvents(Sequence<Ship> ships) {
    for (var ship in ships) {
      scheduleShipEvent(ship);
    }
  }

  /// Schedules an event for [ship].
  ///
  /// If the ship is fighting or has fought, handle the fighting state, else schedule the future events.
  void scheduleShipEvent(Ship ship) {
    final now = DateTime.now();
    final fightEvents = ship.completedEvents
        .toSequence()
        .filterInstance<FightEvent>();
    for(var event in fightEvents) {
      if (isInstantInFight(event.instant, now)) { // check if ship is fighting
        gameLogic.handleFight(ship, event);
      }
    }

    for(var event in ship.futureEvents.toSequence()) {
      buildEventNotification(event);
      scheduleController.scheduleEvent(event.eid, event.duration,
              () => gameLogic.discoverEvent(event.eid, ship.sid)
      );
    }
  }

  /// Deletes the events of [ship] and stops the mobile notification from happening.
  void deleteShipEvent(Ship ship) {
    for(var event in ship.futureEvents.toSequence()) {
      NotificationService.removeNotification(event.eid);
      scheduleController.cancelEvent(event.eid);
    }
  }
}