import 'package:ship_conquest/domain/space/position.dart';

List<Position> defineMiddlePoints(List<Position> path, int numPoints) {
  final int step = ((path.length - 1) / (numPoints - 1)).truncate();

  return List.generate(numPoints, (index) => path[index * step]);
}