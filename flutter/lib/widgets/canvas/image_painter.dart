import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';

class ImagePainter extends CustomPainter {
  final ui.Image image;
  final int size;
  final int length;
  // constructor
  ImagePainter({required this.image, required this.size, required this.length});

  @override
  void paint(Canvas canvas, Size _) {
    const offset = 0.0;

    canvas.drawImageRect(
        image,
        Rect.fromLTRB(
            0, 0, image.width.toDouble(), image.height.toDouble()),
        Rect.fromLTWH(offset, offset, size.toDouble(), size.toDouble()),
        Paint()
    ); // draw image
  }

  @override
  bool shouldRepaint(covariant ImagePainter oldDelegate) => oldDelegate.image != image;
}