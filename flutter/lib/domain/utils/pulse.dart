import 'dart:math';

import 'package:ship_conquest/domain/space/coord_2d.dart';

/// Applies the function [block] for each coordinate within a pulse region
/// with radius [radius].
void pulse<T>({required int radius, required T Function(Coord2D coord) block}) {
  for(int y = - radius; y <= radius; y++) {
    for(int x = - radius; x <= radius; x++) {
      final distance = sqrt((x * x) + (y * y));

      if (radius / distance >= 0.95) {
        block(Coord2D(x: x, y: y));
      }
    }
  }
}