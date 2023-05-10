import 'package:ship_conquest/domain/space/position.dart';

import 'direction.dart';

abstract class Ship {
  int getSid();
  Position getPosition(double scale);
  Direction getDirection();
}