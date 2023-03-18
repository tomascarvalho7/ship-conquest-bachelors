import 'package:flutter/cupertino.dart';

class IsometricTilePaint {
  late final Paint topPaint;
  late final Paint leftPaint;
  late final Paint rightPaint;

  IsometricTilePaint({required Color color}) {
    topPaint = Paint()..color = color;
    leftPaint = Paint()..color = _darkenColor(color, .1);
    rightPaint = Paint()..color = _darkenColor(color, .15);
  }

  Color _darkenColor(Color original, double value) {
    HSVColor originalHSV = HSVColor.fromColor(original);

    return originalHSV
        .withValue(originalHSV.value - value)
        .toColor();
  }
}