import 'package:ship_conquest/domain/space/map_position.dart';

class Node {
  final MapPosition position;
  final double f;
  final double g;
  final double h;
  final Node? parent;

  Node({required this.position, this.f = 0.0, this.g = 0.0, this.h = 0.0, this.parent});

  Node copyWith({double? f, double? g, double? h, Node? parent}) =>
      Node(position: position, f: f ?? this.f, g: g ?? this.g, h: h ?? this.h, parent: parent);
}
