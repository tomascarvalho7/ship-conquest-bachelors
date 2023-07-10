import 'dart:math';

import 'package:ship_conquest/domain/space/position.dart';
import 'package:ship_conquest/utils/constants.dart';


/// Adds a wave's offset into a ship's position
Position addWaveHeightToPos(Position position, double offset) => Position(
    x: position.x,
    y: position.y + sin(offset) * tileSize / 4
);

/// Adds a wave's offset into a ship's position
Position addWaveHeightToPosMoving(Position position, double offset) => Position(
    x: position.x,
    y: position.y + sin(offset) * tileSize / 8
);