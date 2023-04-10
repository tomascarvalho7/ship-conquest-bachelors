
import 'dart:async';

import 'package:ship_conquest/domain/path_finding/find_path.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';
import 'package:ship_conquest/main.dart';

import '../minimap.dart';
import '../space/position.dart';
import '../space/quadratic_bezier.dart';
import 'find_middle_points.dart';

Future<List<QuadraticBezier>> buildPath(
    Minimap map,
    Position start,
    Position mid,
    Position end,
    int radius
    ) async {
  final path = findShortestPath(map, start, end, mid, radius);
  const nrPoints = 2; // change nr of points
  final points = defineMiddlePoints(path, nrPoints * 4);

  getPos(index) => positionFromCoord2D(points[index * 4]);

  return List.generate(
      nrPoints,
      (index) => QuadraticBezier(p0: getPos(0), p1: getPos(1), p2: getPos(2), p3: getPos(3))
  );
}

Position positionFromCoord2D(Coord2D coord) =>
  // offset (to center) + position
  const Position(x: 0.5, y: 0.5) + Position(x: coord.x * tileSize, y: coord.y * tileSize);
