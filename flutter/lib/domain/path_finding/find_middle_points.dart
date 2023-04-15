import '../space/coord_2d.dart';

List<Coord2D> defineMiddlePoints(List<Coord2D> path, int numPoints) {
  final int step = ((path.length - 1) / (numPoints - 1)).truncate();

  return List.generate(numPoints, (index) => path[index * step]);
}