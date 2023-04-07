import 'package:ship_conquest/domain/ship_navigation/distances.dart';
import 'package:ship_conquest/domain/ship_navigation/node.dart';
import 'package:ship_conquest/domain/space/map_position.dart';

double calculateHeuristic(
    MapPosition currPoint, MapPosition end, MapPosition influencePoint) {
  final double distance = calculateManhattanDistance(currPoint, end);
  final double penalty = calculateManhattanDistance(currPoint, influencePoint) / 2;
  return distance + penalty;
}

List<MapPosition> reconstructPath(Node lastNode) {
  final List<Node> path = List.empty(growable: true);
  Node? node = lastNode;
  while (node != null) {
    path.add(node);
    node = node.parent;
  }
  return path.reversed.map((node) => node.position).toList(growable: false);
}

List<Node> calculateNeighbours(Node node, List<MapPosition> map, int safetyRadius,
    int mapSize, List<Node> ignore) {
  final MapPosition pos = node.position;
  final List<Node> resultList = List.empty(growable: true);

  for (int i = pos.x - 1; i <= pos.x + 1; i++) {
    for (int j = pos.y - 1; j <= pos.y + 1; j++) {
      if (i < 0 || i > mapSize || j < 0 || j > mapSize) {
        continue;
      }

      final MapPosition currPos = MapPosition(x: i, y: j);
      final bool isSafe = !map.any(
          (pos) => calculateEuclideanDistance(pos, currPos) <= safetyRadius);
      final bool shouldBeIgnored = ignore.any((node) => node.position == currPos);

      if(!shouldBeIgnored && isSafe && currPos != pos) {
        resultList.add(Node(position: currPos));
      }
    }
  }
  return resultList;
}
