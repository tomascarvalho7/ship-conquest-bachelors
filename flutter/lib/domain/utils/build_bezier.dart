import 'package:ship_conquest/domain/space/coord_2d.dart';
import 'package:ship_conquest/domain/space/cubic_bezier.dart';

/// Builds a list of Bézier curves from a list of points.
List<CubicBezier> buildBeziers(List<Coord2D> points) {
  if (points.length % 4 != 0) return [];

  return List.generate(
      (
          points.length / 4).round(), // length
          (index) => CubicBezier(
              p0: points[index * 4],
              p1: points[(index * 4) + 1],
              p2: points[(index * 4) + 2],
              p3: points[(index * 4) + 3]
          )
    );
}