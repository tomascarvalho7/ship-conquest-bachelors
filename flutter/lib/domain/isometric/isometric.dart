import '../../utils/constants.dart';
import '../space/position.dart';

Position toIsometric(Position position) => Position(
  x: (position.x - position.y) * tileSizeWidthHalf,
  y: (position.x + position.y) * tileSizeHeightHalf,
);