
import 'dart:collection';
import 'dart:math';

import 'package:ship_conquest/domain/minimap.dart';
import 'package:ship_conquest/domain/path_finding/node.dart';
import 'package:ship_conquest/domain/path_finding/utils.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';
import 'package:ship_conquest/domain/utils/distance.dart';
import 'package:ship_conquest/utils/constants.dart';

class PathBuilder {
  final int radius;
  final int maxIterations;
  // constructor
  PathBuilder({required this.radius, this.maxIterations = 250});

  List<Coord2D> build(Minimap map, Coord2D start, Coord2D mid, Coord2D end, int step) {
    if (end.x >= map.length || end.y >= map.length || end.x < 0 || end.y < 0) return [];
    if (map.get(x: end.x, y: end.y) != null && map.get(x: end.x, y: end.y) != waterColor) return [];
    final newNodes = HashMap<Coord2D, Node>(); // map of nodes to be evaluated
    final oldNodes = HashMap<Coord2D, Node>(); // map of nodes already evaluated
    newNodes[start] = Node(position: start); // add the start node to newNodes
    int iterations = 0; // number of iterations

    // keep searching until no more nodes are found, or maxIterations is reached.
    while(newNodes.isNotEmpty || iterations == maxIterations) {
      // get node with lowest f
      final current = newNodes.values.reduce((a, b) => a.f < b.f ? a : b);
      newNodes.remove(current.position); // remove current node from new nodes
      oldNodes[current.position] = current; // add current node to old nodes
      iterations++; // increment iterations
      // if distance is smaller than step, then path has been found
      if (euclideanDistance(current.position, end) <= step) {
        return reconstructPath(Node(position: end, parent: current));
      }

      // get current node neighbours
      final neighbours = calculateNeighbours(current, map, step, radius, oldNodes);
      for(var neighbour in neighbours) {
        // update new path distance to neighbour
        neighbour = neighbour.update(
            g: current.g + euclideanDistance(current.position, neighbour.position),
            h: calculateHeuristic(neighbour.position, end, mid), // calculate heuristic
            parent: current
        );
        // check and get already visited neighbour node
        final oldNeighbour = newNodes[neighbour.position];
        if(oldNeighbour == null || neighbour.f < oldNeighbour.f) {
          // if shorter or not in new nodes, add current neighbour
          newNodes[neighbour.position] = neighbour;
        }
      }
    }

    return [];
  }

  List<Coord2D> normalize(List<Coord2D> path, int size) {
    if (path.isEmpty) return [];

    final length = size * 4;
    final step = ((path.length - 1) / (length - 1)).ceil();

    return List.generate(length, (index) {
      if (index == 0) return path[0];

      return path[min(index * 4 * step, path.length - 1)];
    });
  }
}