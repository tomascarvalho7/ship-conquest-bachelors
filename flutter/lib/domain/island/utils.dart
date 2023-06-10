import 'package:ship_conquest/utils/constants.dart';

import '../space/position.dart';
import '../utils/distance.dart';
import 'island.dart';

/// Helpful utility functions for the all the classes
/// that implement the [Island] interface.
extension Utils on Island {
  /// extension function to check if a [Position]
  /// is close to a [Island] entity, based on a
  /// defined criteria.
  bool isCloseTo(Position position) =>
      distance(coordinate.toPosition(), position) <= radius * 2;

  bool isOwnedByUser() => switch(this) {
    OwnedIsland(owned: final o) => o,
    WildIsland() => false
  };

  int conquestCost() => switch(this) {
    OwnedIsland() => ownedIslandCost,
    WildIsland() => wildIslandCost
  };
}