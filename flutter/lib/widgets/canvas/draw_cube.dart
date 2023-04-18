import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:ship_conquest/domain/isometric/isometric_tile_paint.dart';
import 'package:ship_conquest/domain/space/position.dart';

// draw a isometric cube on [position] with specified [height] and [size] and painted with [paint]
void drawCube({
  required Position position,
  required double size,
  required IsometricTilePaint tilePaint,
  required Canvas canvas
}) {
  Offset offset = Offset(position.x - size / 2, position.y - size / 4); // adjust the offset based on the size
  // top face
  Vertices verticesTF = Vertices(
    VertexMode.triangles,
    [
      // first triangle
      offset + Offset(0, size / 4), // left edge
      offset + Offset(size / 2, 0), // top edge
      offset + Offset(size, size / 4), // right edge
      // second
      offset + Offset(0, size / 4), // left edge
      offset + Offset(size / 2, size / 2), // bottom edge
      offset + Offset(size, size / 4), // right edge
    ],
  );
  canvas.drawVertices(verticesTF, BlendMode.color, tilePaint.topPaint);

  // left face
  Vertices verticesLF = Vertices(
    VertexMode.triangles,
    [
      // first triangle
      offset + Offset(0, size / 4), // left edge
      offset + Offset(size / 2, size / 2), // top edge
      offset + Offset(size / 2, size * 2), // right edge
      // second
      offset + Offset(0, size / 4), // left edge
      offset + Offset(0, size * 2 - size / 4), // bottom edge
      offset + Offset(size / 2, size * 2), // right edge
    ],
  );
  canvas.drawVertices(verticesLF, BlendMode.color, tilePaint.leftPaint);

  // right face
  Vertices verticesRF = Vertices(
    VertexMode.triangles,
    [
      // first triangle
      offset + Offset(size, size / 4), // right edge
      offset + Offset(size / 2, size / 2), // top edge
      offset + Offset(size / 2, size * 2), // left edge
      // second
      offset + Offset(size, size / 4), // right edge
      offset + Offset(size, size * 2 - size / 4), // bottom edge
      offset + Offset(size / 2, size * 2), // left edge
    ],
  );
  canvas.drawVertices(verticesRF, BlendMode.color, tilePaint.rightPaint);
}