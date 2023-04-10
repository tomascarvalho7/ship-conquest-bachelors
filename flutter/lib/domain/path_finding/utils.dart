import 'dart:ui';

import 'package:ship_conquest/domain/minimap.dart';

import '../space/coord_2d.dart';
import '../utils/pulse.dart';
import 'distances.dart';
import 'node.dart';

double calculateHeuristic(
    Coord2D currPoint, Coord2D end, Coord2D influencePoint) {
  final double distance = calculateManhattanDistance(currPoint, end);
  final double penalty = calculateManhattanDistance(currPoint, influencePoint) / 2;
  return distance + penalty;
}

List<Coord2D> reconstructPath(Node lastNode) {
  final List<Node> path = List.empty(growable: true);
  Node? node = lastNode;
  while (node != null) {
    path.add(node);
    node = node.parent;
  }
  return path.reversed.map((node) => node.position).toList(growable: false);
}

List<Node> calculateNeighbours(
    Node node,
    Minimap map,
    int safetyRadius,
    List<Node> ignore
    ) {
  final Coord2D pos = node.position;
  final List<Node> resultList = List.empty(growable: true);

  for (int i = pos.x - 1; i <= pos.x + 1; i++) {
    for (int j = pos.y - 1; j <= pos.y + 1; j++) {
      if (i < 0 || i > map.length || j < 0 || j > map.length) {
        continue;
      }

      bool isSafe = true; // variable
      final Coord2D currPos = Coord2D(x: i, y: j);
      pulse(
        radius: safetyRadius,
        block: (coord) {
          Coord2D newPos = Coord2D(x: coord.x + i, y: coord.y + j);
          Color? value = map.get(x: newPos.x, y: newPos.y);

          if (value != null) { // if there is an obstacle then it's not safe
            isSafe = false;
          }
        }
      );
      final bool shouldBeIgnored = ignore.any((node) => node.position == currPos);

      if(!shouldBeIgnored && isSafe && currPos != pos) {
        resultList.add(Node(position: currPos));
      }
    }
  }
  return resultList;
}


