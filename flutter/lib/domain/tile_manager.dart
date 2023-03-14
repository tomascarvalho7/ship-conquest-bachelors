import 'package:flutter/services.dart';
import 'package:ship_conquest/domain/colorGradient.dart';
import 'factor.dart';
import '../providers/svg_gradient.dart';

class TileManager {
  final String svg;
  final ColorGradient colorGradient;
  final Factor step;
  late final SVGGradient svgGradient;


  TileManager({required this.svg, required this.colorGradient, required this.step}) {
    // build [ImageGradient] from svg string
    svgGradient = SVGGradient(
        svg: svg,
        colorGradient: colorGradient,
        step: step
    );
  }

  String getSvg(int index) {
    return svgGradient.buildSVGList[index];
  }
}