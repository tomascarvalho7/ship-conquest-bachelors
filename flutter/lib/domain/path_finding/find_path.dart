import 'dart:collection';

import 'package:ship_conquest/domain/minimap.dart';
import 'package:ship_conquest/domain/path_finding/utils.dart';
import 'package:ship_conquest/domain/space/position.dart';

import 'distances.dart';
import 'node.dart';

List<Position> findShortestPath(
    Minimap map,
    Position start,
    Position end,
    Position influencePoint,
    int safetyRadius
    ) {
  final double startH = calculateHeuristic(start, end, influencePoint);
  final Node startNode = Node(position: start, h: startH, f: startH);
  final List<Node> foundNodes = List.empty(growable: true);
  foundNodes.add(startNode);
  final HashMap<int, Node> exploredNodes = HashMap();

  while (foundNodes.isNotEmpty) {
    final Node currNode = foundNodes.reduce((firstNode, secondNode) =>
        firstNode.f < secondNode.f ? firstNode : secondNode);
    if (currNode.position == end) {
      return reconstructPath(currNode);
    }
    foundNodes.remove(currNode);
    exploredNodes[exploredNodes.length + 1] = currNode;
    final List neighbors = calculateNeighbours(currNode, map, safetyRadius, exploredNodes);

    for(Node currNeighbour in neighbors) {
      if(exploredNodes.containsValue(currNeighbour)) {
        continue;
      }

      final double tempG = currNode.g + calculateEuclideanDistance(currNode.position, currNeighbour.position);

      final Node neighbourNode = foundNodes.firstWhere((node) => node.position == currNeighbour.position, orElse: () => currNeighbour);

      if(tempG < neighbourNode.g || !foundNodes.contains(currNeighbour)) {
        final double h = calculateHeuristic(currNeighbour.position, end, influencePoint);
        final Node copyNode = currNeighbour.copyWith(g: tempG, h: h, f: tempG + h, parent: currNode);

        Node? existingNode;
        existingNode = foundNodes.firstOrNull((node) => node.position == copyNode.position);

        if(existingNode != null) {
          if(copyNode.f < existingNode.f) {
            foundNodes.add(copyNode);
            foundNodes.remove(existingNode);
          }
        } else {
          foundNodes.add(copyNode);
        }
      }
    }
  }
  return List.empty(growable: false);
}

extension FirstOrNull on List<Node> {
  Node? firstOrNull(bool Function(Node) condition) {
    for(var node in this) {
      if(condition(node)) {
        return node;
      }
    }
    return null;
  }
}
