import 'package:ship_conquest/domain/space/position.dart';

import 'direction.dart';

abstract class Ship {
  Position getPosition(double scale);
  Direction getOrientation();
}