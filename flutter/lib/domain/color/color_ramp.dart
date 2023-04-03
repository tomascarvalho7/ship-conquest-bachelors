import 'dart:ui';
import 'package:ship_conquest/domain/color/color_mark.dart';
import '../utils/factor.dart';

/// Replicate the colorRamp node from blender
class ColorRamp {
  final List<ColorMark> colors;

  ColorRamp({required this.colors});

  Color getColor(Factor factor) {
    int n = 0;
    while(n < colors.length - 1) {
      ColorMark start = colors[n];
      ColorMark end = colors[n + 1];

      Factor scopedFactor = Factor(
          (factor.value - start.factor.value) / (end.factor.value - start.factor.value)
      );

      if (factor.value <= end.factor.value) {
        Color? col = Color.lerp(start.color, end.color, scopedFactor.value);

        if (col != null) { return col; }
      }

      n++;
    }

    // return white
    return const Color(0x00000000);
  }
}