import 'package:ship_conquest/domain/space/position.dart';

import 'space/coord_2d.dart';

class Ship {
  final List<Coord2D> path;
  late final bool static = path.isEmpty;

  Ship({required this.path});

  Position getPosition() {
    // TODO
    return const Position(x: 0, y: 0);
  }
}