import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ship_conquest/domain/color/color_gradient.dart';
import 'package:ship_conquest/domain/color/color_mark.dart';
import 'package:ship_conquest/domain/color/color_ramp.dart';
import 'package:ship_conquest/domain/utils/factor.dart';
import 'package:ship_conquest/utils/constants.dart';

void main() {
  group(
      "Color gradient group",
      () {
        // using the game's gradient
        test("Check same heights retrieve equal gradient colors", () =>
            expect(colorGradient.get(10), colorGradient.get(10))
        );

        test("Check different height retrieve different gradient colors", () =>
          expect(colorGradient.get(10), isNot(colorGradient.get(11)))
        );

        test("Instantiate new color ramp and test it", () {
          // define ramp colors
          const ramp = ColorRamp(colors: [
            ColorMark(factor: Factor(value: 0.0), color: Colors.white),
            ColorMark(factor: Factor(value: 1.0), color: Colors.black)
          ]);
          // generate a color gradient from white to black with 500 different colors
          final gradient = ColorGradient(colorRamp: ramp, step: const Factor(value: 0.002));
          // expect the first to be white and the last to be black
          expect(gradient.get(0), Colors.white);
          expect(gradient.get(499), Colors.black);
          // expect middle colors to not be either color, but a shade of them
          expect(gradient.get(200), isNot(Colors.white));
          expect(gradient.get(200), isNot(Colors.black));
        }
        );
      }
  );
}
