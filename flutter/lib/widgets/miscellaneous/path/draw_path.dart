import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/space/pathPoints.dart';
import '../../canvas/path_painter.dart';

class DrawPath extends StatelessWidget {
  final PathPoints? pathPoints;
  final Color start;
  final Color mid;
  final Color end;
  const DrawPath({super.key, required this.pathPoints, required this.start, required this.mid, required this.end});

  @override
  Widget build(BuildContext context) {
    final points = pathPoints;
    if (points == null) return const SizedBox();

    return CustomPaint(
        painter: PathPainter(
          points: points,
          start: start,
          mid: mid,
          end: end
        )
    );
  }

}