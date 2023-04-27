import 'dart:ui';

import 'package:ship_conquest/domain/island/island.dart';
import 'package:ship_conquest/domain/island/owned_island.dart';

String getIslandLabel(Island island)  =>
    island is OwnedIsland
        ? "Owned island"
        : "Wild island";

String getIslandDetails(Island island)  =>
    island is OwnedIsland
        ? "Player owned island"
        : "Undiscovered island";

Color getIslandColor(Island island)  =>
    island is OwnedIsland
        ? const Color.fromRGBO(162, 56, 56, 1.0)
        : const Color.fromRGBO(56, 162, 110, 1.0);