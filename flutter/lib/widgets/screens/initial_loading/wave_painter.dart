import 'package:flutter/material.dart';
import 'dart:math' as math;

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    const waveColor = Colors.blue;
    const waveAmplitude = 15.0;
    const waveFrequency = 1.5;
    const waveSpeed = 200.0;

    final wavePath = Path();
    final wavePaint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill;

    final waveWidth = size.width;
    final waveHeight = size.height / 2;
    final baseY = size.height / 2;

    wavePath.moveTo(0, baseY);

    for (double x = 0; x <= waveWidth; x += 1) {
      final y = baseY +
          waveAmplitude *
              math.sin((x / waveWidth * waveFrequency * 2 * math.pi) -
                  (animationValue * waveSpeed / waveWidth * 2 * math.pi));
      wavePath.lineTo(x, y);
    }

    wavePath.lineTo(waveWidth, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    final clipPath = Path()
      ..addOval(Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2));

    canvas.clipPath(clipPath);  // Clip the canvas to the circular shape
    canvas.drawPath(wavePath, wavePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}