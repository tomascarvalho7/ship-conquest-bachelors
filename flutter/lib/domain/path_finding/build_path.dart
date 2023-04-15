import 'dart:async';
import 'package:ship_conquest/domain/path_finding/find_path.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';
import 'package:ship_conquest/main.dart';

import '../minimap.dart';
import '../space/position.dart';
import '../space/cubic_bezier.dart';
import 'find_middle_points.dart';
/*
Future<List<QuadraticBezier>> buildPathTask(
    Minimap map,
    Position start,
    Position mid,
    Position end,
    int radius
    ) async {
  await Future.delayed(const Duration(seconds: 1));
  final path = findShortestPath(map, toCoord2D(start), toCoord2D(end), toCoord2D(mid), radius);
  const nrPoints = 2; // change nr of points
  final points = defineMiddlePoints(path, nrPoints * 4);

  getPos(index, iteration) => positionWithOffset(points[(index * 4) + iteration]);

  return List.generate(
      nrPoints,
          (index) => QuadraticBezier(p0: getPos(index, 0), p1: getPos(index, 1), p2: getPos(index, 2), p3: getPos(index, 3))
  );
}

Coord2D toCoord2D(Position position) => Coord2D(x: position.x.round(), y: position.y.round());

Position positionWithOffset(Coord2D pos) =>
  // offset (to center) + position
  const Position(x: 0.5, y: 0.5) + Position(x: pos.x.toDouble(), y: pos.y.toDouble());
*/
