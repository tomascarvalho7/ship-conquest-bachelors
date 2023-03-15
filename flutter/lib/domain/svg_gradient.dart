import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ship_conquest/domain/hex_color.dart';
import 'package:ship_conquest/domain/color_gradient.dart';
import 'package:ship_conquest/main.dart';

import 'factor.dart';

/// Build a set of svg strings based on a transformation with a colorGradient instance
class SVGGradient {
  final String svg;
  final ColorGradient colorGradient;
  final Factor step;
  late final List<Widget> widgetList;

  SVGGradient({
    required this.svg,
    required this.colorGradient,
    required this.step
  }) {
    widgetList = List.generate(
        (1 / step.value).round(),
            (index) {
              Factor factor = Factor(index * step.value);
              Color color = colorGradient.getColor(factor);
              return SvgPicture.string(
                  editSVG(color),
                  width: tileSize,
                  height: tileSize * 2,
              );
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