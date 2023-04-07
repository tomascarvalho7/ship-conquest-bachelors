import 'package:ship_conquest/domain/ship_navigation/distances.dart';
import 'package:ship_conquest/domain/ship_navigation/node.dart';
import 'package:ship_conquest/domain/ship_navigation/utils.dart';
import 'package:ship_conquest/domain/space/map_position.dart';


List<MapPosition> findShortestPath(List<MapPosition> map, MapPosition start,
    MapPosition end, MapPosition influencePoint, int safetyRadius, int mapSize) {
  final double startH = calculateHeuristic(start, end, influencePoint);
  final Node startNode = Node(position: start, h: startH, f: startH);
  final List<Node> foundNodes = List.empty(growable: true);
  foundNodes.add(startNode);
  final List<Node> exploredNodes = List.empty(growable: true);

  while (foundNodes.isNotEmpty) {
    final Node currNode = foundNodes.reduce((firstNode, secondNode) =>
        firstNode.f < secondNode.f ? firstNode : secondNode);
    if (currNode.position == end) {
      return reconstructPath(currNode);
    }
    foundNodes.remove(currNode);
    exploredNodes.add(currNode);
    final List<Node> neighbors = calculateNeighbours(currNode, map, safetyRadius, mapSize, exploredNodes);

    for(Node currNeighbour in neighbors) {
      if(exploredNodes.contains(currNeighbour)) {
        continue;
      }

      final double tempG = currNode.g + calculateEuclideanDistance(currNode.position, currNeighbour.position);

      final Node neighbourNode = foundNodes.firstWhere((node) => node.position == currNeighbour.position, orElse: () => currNeighbour);

      if(tempG < neighbourNode.g || !foundNodes.contains(currNeighbour)) {
        final double h = calculateHeuristic(currNeighbour.position, end, influencePoint);
        final Node copyNode = currNeighbour.copyWith(g: tempG, h: h, f: tempG + h, parent: currNode);

        Node? existingNode;
        try {
          existingNode = foundNodes.firstWhere((node) => node.position == copyNode.position);
        } catch (error) {
          existingNode = null;
        }
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
