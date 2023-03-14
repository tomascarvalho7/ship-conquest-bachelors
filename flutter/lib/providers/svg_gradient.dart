import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/HexColor.dart';
import 'package:ship_conquest/domain/colorGradient.dart';

import '../domain/factor.dart';

/// Build a set of svg strings based on a transformation with a colorGradient instance
class SVGGradient {
  final String svg;
  final ColorGradient colorGradient;
  final Factor step;
  late final List<String> buildSVGList;

  SVGGradient({
    required this.svg,
    required this.colorGradient,
    required this.step
  }) {
    buildSVGList = List.generate(
        (1 / step.value).round(),
            (index) {
              Factor factor = Factor(index * step.value);
              Color color = colorGradient.getColor(factor);
              return editSVG(color);
            }
    );
  }

  String editSVG(Color color) {
    return svg.replaceAllMapped(RegExp(r"(#)\w+"), (match) {
      Color matchColor = HexColor.fromHex(match[0]!);
      Color result = colorOperation(matchColor, color);
      return result.toHex().replaceRange(0, 3, "#");
    });
  }

  Color colorOperation(Color a, Color b) {
    HSVColor hsvA = HSVColor.fromColor(a);
    HSVColor hsvB = HSVColor.fromColor(b);
    return HSVColor.fromAHSV(hsvA.alpha, hsvB.hue, hsvB.saturation, hsvA.value).toColor();
  }
}