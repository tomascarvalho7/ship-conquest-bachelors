import 'package:ship_conquest/domain/space/map_position.dart';

List<MapPosition> defineMiddlePoints(List<MapPosition> path, int numPoints) {
  List<MapPosition> extractedPoints = List.empty(growable: true);
  final double step = (path.length - 1).toDouble() / (numPoints - 1).toDouble();
  for(int i = 0; i < numPoints; i++) {
    final int index = (i * step).toInt();
    extractedPoints.add(path[index]);
  }
  return extractedPoints;
}