import 'dart:ui';

import 'package:ship_conquest/domain/space/position.dart';

extension OffsetParsing on Offset {
  /// Extends Offset class and transforms it into a Position instance.
  Position toPosition() => Position(x: dx, y: dy);
}