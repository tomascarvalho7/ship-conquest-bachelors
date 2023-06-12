import 'package:ship_conquest/domain/event/known_event.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/utils/constants.dart';

/// Helpful logical functions for the all the classes
/// that implement the [Ship] interface.
extension Logic on Ship {
  /// [True] if ship is currently fighting in this [Instant]
  /// otherwise return [False]
  bool isFighting(DateTime instant) {
    final fightEvents = completedEvents
        .toSequence() // Grid => Sequence
        .filterInstance<FightEvent>(); // keep only the [FightEvent] instances

    for (var event in fightEvents) {
      // check if fight is currently on going
      if (isInstantInFight(event.instant, instant)) return true;
    }

    return false; // by default return false
  }
}

bool isInstantInFight(DateTime fightInstant, DateTime instant) =>
  fightInstant.isBefore(instant) &&
      fightInstant.isAfter(instant.subtract(fightDuration));