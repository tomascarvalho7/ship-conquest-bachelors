import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as img;
import 'package:ship_conquest/domain/colorGradient.dart';

import '../domain/factor.dart';

/// Build a set of images based on a transformation with a colorGradient instance
class ImageGradient {
  final img.Image image;
  final ColorGradient colorGradient;
  final Factor step;
  late final Uint32List imageData;
  late final List<img.Image> imageList;

  ImageGradient({
    required this.image,
    required this.colorGradient,
    required this.step
  }) {
    imageData = image.buffer.asUint32List();
    imageList = List.generate(
        (1 / step.value).round(),
            (index) {
              Factor factor = Factor(index * step.value);
              Color color = colorGradient.getColor(factor);
              return generateImage(color);
            }
    );
  }

  img.Image generateImage(Color color) {
    int length = image.width * image.height;
    Int32List pixels = Int32List(length);

    for(var index = 0; index < length; index++) {
      pixels[index] = colorOperation(Color(imageData[index]), color).value;
    }

    // create Image
    return img.Image.fromBytes(
        width: image.width,
        height: image.height,
        bytes: pixels.buffer,
        numChannels: 4
    );
  }

  Color colorOperation(Color a, Color b) {
    HSVColor hsvA = HSVColor.fromColor(a);
    HSVColor hsvB = HSVColor.fromColor(b);
    return HSVColor.fromAHSV(hsvA.alpha, hsvB.hue, hsvB.saturation, hsvA.value).toColor();
  }
}