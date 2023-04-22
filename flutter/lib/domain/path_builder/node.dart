import '../space/coord_2d.dart';

class Node {
  final Coord2D position;
  final double f;
  final double g;
  final double h;
  final Node? parent;

  Node({required this.position, this.f = 0.0, this.g = 0.0, this.h = 0.0, this.parent});

  Node update({double? g, double? h, Node? parent}) {
    final newG = g ?? this.g;
    final newH = h ?? this.h;
    return Node(position: position, f: newG + newH, g: newG, h: newH, parent: parent);
  }
}
