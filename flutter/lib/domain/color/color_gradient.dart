import 'package:flutter/material.dart';
import 'package:ship_conquest/domain/color/color_ramp.dart';
import 'package:ship_conquest/domain/utils/factor.dart';

/// Build a set of colors based on a transformation with a ColorRamp
/// instance [colorRamp] and a [step].
class ColorGradient {
  final ColorRamp colorRamp;
  final Factor step;
  late final List<Color> colors = List.generate(
      (1 / step.value).round(),
          (index) {
        Factor factor = Factor(value: index * step.value);
        return colorRamp.getColor(factor);
      }
  );

  ColorGradient({
    required this.colorRamp,
    required this.step
  });

  /// Gets the color from the gradient at a given [height].
  Color get(int height) => colors[height];
}