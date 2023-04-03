import 'dart:ui';

import 'position.dart';

extension OffsetParsing on Offset {
  Position toPosition() => Position(x: dx, y: dy);
}