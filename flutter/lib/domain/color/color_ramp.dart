import 'package:flutter/material.dart';
import 'package:ship_conquest/domain/color/color_mark.dart';
import 'package:ship_conquest/domain/utils/factor.dart';

/// Replicate the colorRamp node from Blender
class ColorRamp {
  final List<ColorMark> colors;

  const ColorRamp({required this.colors});

  /// Gets the gradient color with a given [factor] from the list of colors [colors]
  Color getColor(Factor factor) {
    int n = 0;
    while(n < colors.length - 1) {
      ColorMark start = colors[n];
      ColorMark end = colors[n + 1];

      Factor scopedFactor = Factor(value:
          (factor.value - start.factor.value) / (end.factor.value - start.factor.value)
      );

      if (factor.value <= end.factor.value) {
        Color? col = Color.lerp(start.color, end.color, scopedFactor.value);

        if (col != null) { return col; }
      }
      n++;
    }

    // return transparent
    return const Color(0x00000000);
  }
}