import 'package:ship_conquest/domain/event/known_event.dart';
import 'package:ship_conquest/domain/immutable_collections/utils/extend_grid.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/domain/ship/utils/classes/ship_path.dart';
import 'package:ship_conquest/utils/constants.dart';

import '../../immutable_collections/sequence.dart';
import '../../space/coord_2d.dart';

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

/// Check if the ship is fighting by comparing the fight's instant to the current instant.
bool isInstantInFight(DateTime fightInstant, DateTime instant) =>
  fightInstant.isBefore(instant) &&
      fightInstant.isAfter(instant.subtract(fightDuration));