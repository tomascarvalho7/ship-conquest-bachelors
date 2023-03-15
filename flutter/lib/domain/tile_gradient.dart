import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/color_gradient.dart';
import 'factor.dart';
import 'svg_gradient.dart';

class TileGradient {
  final String svg;
  final ColorGradient colorGradient;
  final Factor step;
  late final SVGGradient svgGradient;

  TileGradient({required this.svg, required this.colorGradient, required this.step}) {
    // build [ImageGradient] from svg string
    svgGradient = SVGGradient(
        svg: svg,
        colorGradient: colorGradient,
        step: step
    );
  }

  Widget getSvg(int index) {
    return svgGradient.widgetList[index];
  }
}