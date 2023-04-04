import 'package:flutter/material.dart';

import '../../domain/path/path_points.dart';
import '../../domain/space/position.dart';

class PathPainter extends CustomPainter {
  final List<Position> hooks;
  final PathPoints? points;
  final Color start;
  final Color mid;
  final Color end;
  // constructor
  PathPainter({required this.hooks, required this.points, required this.start, required this.mid, required this.end});

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
      drawPoint(canvas, hooks[i], start);
    }
  }

  void drawPoint(Canvas canvas, Position position, Color color) {
    canvas.drawCircle(position.toOffset(), 10, Paint()..color = color);
  }

  void paintPath(Canvas canvas, Position start, Position mid, Position end, double distance) {
    final paint = Paint()
      ..shader = RadialGradient(
          colors: [this.start, this.mid, this.end]
      ).createShader(Rect.fromCircle(center: start.toOffset(), radius: distance))
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    Path bezierPath = Path()
      ..moveTo(start.x, start.y)
      ..quadraticBezierTo(mid.x, mid.y, end.x, end.y);

    canvas.drawPath(bezierPath, paint);
  }

  @override
  bool shouldRepaint(covariant PathPainter oldDelegate) => true;
}