import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/isometric_tile_paint.dart';
import 'package:ship_conquest/domain/position.dart';

import 'coordinate.dart';

class IsometricTile {
  final Position position; // tile origin
  final double Function(double x) height; // tile get height function
  final IsometricTilePaint Function(double x) tilePaint; // tile get paint

  IsometricTile({required this.position, required this.height, required this.tilePaint});

  // create a isometric tile from a static terrain tile
  static IsometricTile fromTerrainTile({
    required Coordinate coordinate,
    required double tileSize,
    required Color color
  }) {
    double tileSizeWidthHalf = tileSize / 2;
    double tileSizeHeightHalf = tileSizeWidthHalf / 2;
    final paint = IsometricTilePaint(color: color);

    return IsometricTile(
        position: Position(
          x: (coordinate.x - coordinate.y) * tileSizeWidthHalf,
          y: (coordinate.x + coordinate.y - (coordinate.z / 10)) * tileSizeHeightHalf,
        ),
        height: (double x) => 0, // always return 0
        tilePaint: (double x) => paint // always return the same color
    );
  }

  // create a isometric tile from a moving water tile
  static IsometricTile fromWaterTile({
    required Coordinate coordinate,
    required double tileSize,
    required Color color
  }) {
    double tileSizeWidthHalf = tileSize / 2;
    double tileSizeHeightHalf = tileSizeWidthHalf / 2;
    double tileSizeDouble = tileSize * 2;
    double waveOffset = (coordinate.x + coordinate.y) / -3;

    return IsometricTile(
        position: Position(
          x: (coordinate.x - coordinate.y) * tileSizeWidthHalf,
          y: (coordinate.x + coordinate.y) * tileSizeHeightHalf,
        ),
        height: (double x) => sin(x + waveOffset) * tileSizeHeightHalf,
        tilePaint: (double height) => IsometricTilePaint(
            color: HSVColor
                .fromColor(color)
                .withValue(.75 + (1 - height) / tileSizeDouble)
                .toColor()
        )
    );
  }
}