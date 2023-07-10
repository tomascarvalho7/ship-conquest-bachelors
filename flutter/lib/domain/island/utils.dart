import 'package:ship_conquest/domain/island/island.dart';
import 'package:ship_conquest/domain/space/position.dart';
import 'package:ship_conquest/domain/utils/distance.dart';
import 'package:ship_conquest/utils/constants.dart';

/// Helpful utility functions for the all the classes
/// that implement the [Island] interface.
extension Utils on Island {
  /// Extension function to check if a [Position] is close to a [Island] entity,
  /// based on a defined criteria.
  bool isCloseTo(Position position) =>
      distance(coordinate.toPosition(), position) <= radius * 1.25;

  /// Extension function to check if an island is owned by any user.
  bool isOwnedByUser() => switch(this) {
    OwnedIsland(owned: final o) => o,
    WildIsland() => false
  };

  /// Extension function to retrieve the cost of an island.
  int conquestCost() => switch(this) {
    OwnedIsland() => ownedIslandCost,
    WildIsland() => wildIslandCost
  };
}