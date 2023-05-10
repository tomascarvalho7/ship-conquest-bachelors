import 'package:flutter/material.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';

import '../../domain/path/path_points.dart';
import '../../domain/space/position.dart';

class RoutePainter extends CustomPainter {
  final Sequence<Position> hooks;
  final PathPoints? points;
  final double scale;
  final Color start;
  final Color mid;
  final Color end;
  // constructor
  RoutePainter({required this.hooks, required this.points, required this.scale, required this.start, required this.mid, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    final points = this.points;
    // if points are defined paint path !
    if (points != null) {
      paintPath(canvas, points.start, points.mid, points.end, points.distance);

      drawPoint(canvas, points.mid, mid);
      drawPoint(canvas, points.end, end);
    }

    final length = hooks.length;
    for(var i = 0; i < length; i++) {
      drawPoint(canvas, hooks.get(i), start);
    }
  }

  void drawPoint(Canvas canvas, Position position, Color color) {
    canvas.drawCircle(position.toOffset(), 15 / scale, Paint()..color = color);
  }

  void paintPath(Canvas canvas, Position start, Position mid, Position end, double distance) {
    final paint = Paint()
      ..shader = RadialGradient(
          colors: [this.start, this.mid, this.end]
      ).createShader(Rect.fromCircle(center: start.toOffset(), radius: distance))
      ..strokeWidth = 12.5 / scale
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    Path bezierPath = Path()
      ..moveTo(start.x, start.y)
      ..quadraticBezierTo(mid.x, mid.y, end.x, end.y);

    canvas.drawPath(bezierPath, paint);
  }

  @override
  bool shouldRepaint(covariant RoutePainter oldDelegate) => true;
}