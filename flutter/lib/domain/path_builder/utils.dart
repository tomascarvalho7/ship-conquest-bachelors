import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ship_conquest/domain/minimap.dart';

import '../../utils/constants.dart';
import '../space/coord_2d.dart';
import '../utils/distance.dart';
import '../utils/pulse.dart';
import 'node.dart';

double calculateHeuristic(Coord2D currPoint, Coord2D end, Coord2D influencePoint) {
  final double distance = manhattanDistance(currPoint, end);
  final double penalty = manhattanDistance(currPoint, influencePoint) * .75;
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
    int step,
    int safetyRadius,
    HashMap<Coord2D, Node> ignore
    ) {
  final Coord2D pos = node.position;
  final List<Node> resultList = List.empty(growable: true);
  final horizontal = [pos.x - step, pos.x, pos.x + step];
  final vertical = [pos.y - step, pos.y, pos.y + step];

  for (int i in horizontal) {
    for (int j in vertical) {
      if ((i == pos.x && j == pos.y) || i < 0 || i > map.length || j < 0 || j > map.length) {
        continue;
      }

      bool isSafe = true; // variable
      pulse(
        radius: safetyRadius,
        block: (coord) {
          Color? value = map.get(x: coord.x + i, y: coord.y + j);

          if (value != null && value.value != waterColor.value) { // if there is an obstacle then it's not safe
            isSafe = false;
          }
        }
      );

      final Coord2D currPos = Coord2D(x: i, y: j);
      final bool shouldBeIgnored = ignore[currPos] != null;

      if(!shouldBeIgnored && isSafe && currPos != pos) {
        resultList.add(Node(position: currPos));
      }
    }
  }
  return resultList;
}

extension HMAny on HashMap<Coord2D, Node> {
  bool any(bool Function(Node) condition) {
    for(var node in values) {
      if(condition(node)) return true;
    }
    return false;
  }
}