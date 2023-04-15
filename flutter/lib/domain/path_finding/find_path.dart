import 'dart:collection';

import 'package:ship_conquest/domain/minimap.dart';
import 'package:ship_conquest/domain/path_finding/utils.dart';

import '../space/coord_2d.dart';
import 'node.dart';

/*
/// Finds the shortest path between two points on a map, avoiding obstacles and
/// considering an influence point
List<Coord2D> findShortestPath(
    Minimap map,
    Coord2D start,
    Coord2D end,
    Coord2D influencePoint,
    int safetyRadius,
    {int maxIterations = 5000}
    )  {
  // Set up initial nodes and maps
  final startH = calculateHeuristic(start, end, influencePoint);
  final startNode = Node(position: start, h: startH, f: startH);
  final foundNodes = [startNode];
  final exploredNodes = HashMap<Coord2D, Node>();
  var iterations = 0;

  // Keep searching for the shortest path until no more nodes are found, or maxIterations is reached.
  while (foundNodes.isNotEmpty) {
    iterations++;
    // Find the node with the lowest f score
    final currNode = foundNodes.reduce((a, b) => a.f < b.f ? a : b);
    // When the final destination is reached, return the built path
    if (currNode.position == end || iterations == maxIterations) return reconstructPath(currNode);

    foundNodes.remove(currNode);
    exploredNodes[currNode.position] = currNode;

    // Find neighbors of the current node and update their costs
    for (final currNeighbour in calculateNeighbours(currNode, map, safetyRadius, exploredNodes)) {
      if (exploredNodes.containsValue(currNeighbour)) continue;
      final tempG = currNode.g + calculateEuclideanDistance(currNode.position, currNeighbour.position);
      final neighbourNode = foundNodes.firstWhere((node) => node.position == currNeighbour.position, orElse: () => currNeighbour);

      // Update neighbor node if it has a lower cost or hasn't been found yet
      if (tempG < neighbourNode.g || !foundNodes.contains(currNeighbour)) {
        final h = calculateHeuristic(currNeighbour.position, end, influencePoint);
        final copyNode = currNeighbour.update(g: tempG, h: h, f: tempG + h, parent: currNode);

        final existingNode = foundNodes.firstOrNull((node) => node.position == copyNode.position);
        if (existingNode != null && copyNode.f < existingNode.f) {
          foundNodes.add(copyNode);
          foundNodes.remove(existingNode);
        } else if (existingNode == null) {
          foundNodes.add(copyNode);
        }
      }
    }
  }
  return [];
}

// Adds a firstOrNull method to the List class for convenience.
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
*/
