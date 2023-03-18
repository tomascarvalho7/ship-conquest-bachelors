import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/color_ramp.dart';

import 'factor.dart';

/// Build a set of colors based on a transformation with a colorRamp instance
class ColorGradient {
  final ColorRamp colorRamp;
  final Factor step;
  late final List<Color> colors;

  ColorGradient({
    required this.colorRamp,
    required this.step
  }) {
    colors = List.generate(
        (1 / step.value).round(),
            (index) {
              Factor factor = Factor(index * step.value);
              return colorRamp.getColor(factor);
            }
    );
  }

  Color get(int height) => colors[height];
}