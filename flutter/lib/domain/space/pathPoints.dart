import 'dart:math';

import 'package:ship_conquest/domain/space/position.dart';

class PathPoints {
  final Position start;
  final Position mid;
  final Position end;
  late final distance = sqrt(pow(end.x - start.x, 2) + pow(end.y - start.y, 2));

  PathPoints({required this.start, required this.mid, required this.end});
}