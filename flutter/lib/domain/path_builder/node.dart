import 'package:ship_conquest/domain/space/coord_2d.dart';

/// Class holding the information of a [Node] to be used in A* algorithm.
///
/// [position] the node's position;
/// [f] is the node's comparative value;
/// [g] is the node's distance to the starting node;
/// [h] is the node's heuristic value;
/// [parent] is the node's parent.
class Node {
  final Coord2D position;
  final double f;
  final double g;
  final double h;
  final Node? parent;

  Node({required this.position, this.f = 0.0, this.g = 0.0, this.h = 0.0, this.parent});

  /// Function to update a node with new [g], [h] and [parent] values.
  ///
  /// Returns a new [Node] with the updated fields.
  Node update({double? g, double? h, Node? parent}) {
    final newG = g ?? this.g;
    final newH = h ?? this.h;
    return Node(position: position, f: newG + newH, g: newG, h: newH, parent: parent);
  }
}
