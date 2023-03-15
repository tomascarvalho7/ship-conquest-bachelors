import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:ship_conquest/domain/position.dart';

import 'coordinate.dart';

abstract class IsometricTile {
  final double tileSizeWidthHalf;
  final double tileSizeHeightHalf;
  final Coordinate coordinate;
  late final Position position = Position(
    x: (coordinate.x - coordinate.y) * tileSizeWidthHalf,
    y: (coordinate.x + coordinate.y - (coordinate.z / 10)) * tileSizeHeightHalf,
  );

  IsometricTile({required this.coordinate, required this.tileSizeWidthHalf, required this.tileSizeHeightHalf});
}

class TerrainTile extends IsometricTile {
  TerrainTile({required super.coordinate, required super.tileSizeWidthHalf, required super.tileSizeHeightHalf});
}

class WaterTile extends IsometricTile {
  final Animation<num> animation;
  late final double waveOffset = (coordinate.x + coordinate.y) / -3;

  WaterTile({required super.coordinate, required super.tileSizeWidthHalf, required super.tileSizeHeightHalf, required this.animation});

  // getter
  @override
  Position get position => Position(
      x: super.position.x,
      y: super.position.y + sin(animation.value + waveOffset) * tileSizeWidthHalf
  );
}

