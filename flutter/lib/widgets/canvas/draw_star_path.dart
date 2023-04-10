import 'package:flutter/cupertino.dart';

import '../../domain/space/position.dart';
import '../../domain/space/quadratic_bezier.dart';

class DrawStarPath extends CustomPainter {
  final List<QuadraticBezier> beziers;
  // constructor
  DrawStarPath({required this.beziers});

  Color color = const Color.fromRGBO(255, 255, 255, 1);

  @override
  void paint(Canvas canvas, Size size) {
    final length = beziers.length;
    for(var x = 0; x < length; x++) {
      drawBezier(canvas, beziers[x]);
    }
  }

  void drawBezier(Canvas canvas, QuadraticBezier bezier) {
    drawPoint(canvas, bezier.p0, color);
    drawPoint(canvas, bezier.p1, color);
    drawPoint(canvas, bezier.p2, color);
    drawPoint(canvas, bezier.p3, color);
  }

  void drawPoint(Canvas canvas, Position position, Color color) {
    canvas.drawCircle(position.toOffset(), 15, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}