import 'dart:ui';

import 'package:ship_conquest/domain/island/island.dart';
import 'package:ship_conquest/domain/utils/string_cap.dart';

/// Helpful presentation functions for the all the classes
/// that implement the [Island] interface.
extension Presentation on Island {
  String getIslandLabel() => switch (this) {
    OwnedIsland(owned: final ownership) => ownership
        ? "Friendly Island"
        : "Enemy Island",
    WildIsland() => "Wild Island"
  };

  String getIslandDetails() => switch (this) {
    OwnedIsland(owned: final ownership, username: final name) => ownership
        ? "already owned island"
        : "belonging to ${name.cap(15)} forces",
    WildIsland() => "yet undiscovered island"
  };

  Color getIslandColor() => switch (this) {
    OwnedIsland(owned: final ownership) => ownership
        ? const Color.fromRGBO(56, 86, 162, 1.0)
        : const Color.fromRGBO(162, 56, 56, 1.0),
    WildIsland() => const Color.fromRGBO(56, 162, 110, 1.0)
  };
}