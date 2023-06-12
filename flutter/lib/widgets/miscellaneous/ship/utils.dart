import 'dart:math';

import '../../../domain/space/position.dart';
import '../../../utils/constants.dart';

Position addWaveHeightToPos(Position position, double offset) => Position(
    x: position.x,
    y: position.y + sin(offset) * tileSize / 8
);