import 'package:flutter/material.dart';

import '../../domain/color_gradient.dart';
import '../../domain/color_mark.dart';
import '../../domain/color_ramp.dart';
import '../../domain/factor.dart';
import 'game.dart';

class GameScreen extends StatelessWidget {
  GameScreen({Key? key}) : super(key: key);

  final ColorRamp colorRamp = ColorRamp(colors: [
    ColorMark(factor: Factor(0.0), color: Colors.blue),
    ColorMark(factor: Factor(0.01), color: const Color.fromRGBO(196, 195, 175, 1.0)),
    ColorMark(factor: Factor(0.15), color: const Color.fromRGBO(210, 202, 151, 1.0)),
    ColorMark(factor: Factor(0.2), color: const Color.fromRGBO(116, 153, 72, 1.0)),
    ColorMark(factor: Factor(0.3), color: const Color.fromRGBO(77, 130, 40, 1.0)),
    ColorMark(factor: Factor(0.7), color: const Color.fromRGBO(177, 211, 114, 1.0)),
    ColorMark(factor: Factor(0.71), color: const Color.fromRGBO(170, 145, 107, 1.0)),
    ColorMark(factor: Factor(0.85), color: const Color.fromRGBO(157, 117, 64, 1.0)),
    ColorMark(factor: Factor(1.0), color: const Color.fromRGBO(255, 255, 255, 1.0)),
  ]);

  @override
  Widget build(BuildContext context) {
    return Grid(
        background: Colors.blueAccent,
        colorGradient: ColorGradient(colorRamp: colorRamp, step: Factor(0.01)));
  }
}
