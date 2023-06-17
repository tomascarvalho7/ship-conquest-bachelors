import 'package:ship_conquest/domain/space/position.dart';
import 'package:ship_conquest/utils/constants.dart';

/// Function to apply a transformation to a [Position].
///
/// The retrieved [Position] is in isometric perspective.
Position toIsometric(Position position) => Position(
  x: (position.x - position.y) * tileSizeWidthHalf,
  y: (position.x + position.y) * tileSizeHeightHalf,
);