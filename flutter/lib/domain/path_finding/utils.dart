import 'dart:collection';
import 'dart:ui';

import 'package:ship_conquest/domain/minimap.dart';

import '../space/position.dart';
import '../utils/pulse.dart';
import 'distances.dart';
import 'node.dart';

double calculateHeuristic(
    Position currPoint, Position end, Position influencePoint) {
  final double distance = calculateManhattanDistance(currPoint, end);
  final double penalty = calculateManhattanDistance(currPoint, influencePoint) / 2;
  return distance + penalty;
}

List<Position> reconstructPath(Node lastNode) {
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
    HashMap<int, Node> ignore
    ) {
  final Position pos = node.position;
  final List<Node> resultList = List.empty(growable: true);

  for (double i = pos.x - 1; i <= pos.x + 1; i++) {
    for (double j = pos.y - 1; j <= pos.y + 1; j++) {
      if (i < 0 || i > map.length || j < 0 || j > map.length) {
        continue;
      }

      bool isSafe = true; // variable
      final Position currPos = Position(x: i, y: j);
      pulse(
        radius: safetyRadius,
        block: (coord) {
          Position newPos = Position(x: coord.x + i, y: coord.y + j);
          Color? value = map.get(x: newPos.x.toInt(), y: newPos.y.toInt());

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

extension HMAny on HashMap<int, Node> {
  bool any(bool Function(Node) condition) {
    for(var node in values) {
      if(condition(node)) return true;
    }
    return false;
  }
}