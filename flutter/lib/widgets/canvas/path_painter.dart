import 'package:flutter/material.dart';

import '../../domain/space/pathPoints.dart';

class PathPainter extends CustomPainter {
  final PathPoints points;
  final Color start;
  final Color mid;
  final Color end;
  // constructor
  PathPainter({required this.points, required this.start, required this.mid, required this.end});

  late final _paint = Paint()
    ..shader = RadialGradient(
        colors: [
          start,
          mid,
          end
        ]
    ).createShader(Rect.fromCircle(center: points.start.toOffset(), radius: points.distance))
    ..strokeWidth = 10
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    final start = points.start;
    final mid = points.mid;
    final end = points.end;
    Path bezierPath = Path()
      ..moveTo(start.x, start.y)
      ..quadraticBezierTo(mid.x, mid.y, end.x, end.y);

    canvas.drawPath(bezierPath, _paint);
  }

  @override
  bool shouldRepaint(covariant PathPainter oldDelegate) => end != oldDelegate.end;
}