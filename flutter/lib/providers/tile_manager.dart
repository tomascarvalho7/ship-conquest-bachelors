import 'package:flutter/services.dart';
import 'package:ship_conquest/domain/colorGradient.dart';
import '../domain/factor.dart';
import 'image_gradient.dart';
import 'package:image/image.dart';

class TileManager {
  final ColorGradient colorGradient;
  final Factor step;
  late final ImageGradient imageGradient;
  late final List<Uint8List> pngList;

  TileManager({required this.colorGradient, required this.step}) {
    rootBundle.load('assets/images/simple_block.png').then(
            (value) {
              print("start");
              // Create PNG decoder and encoders,
              PngDecoder decoder = PngDecoder();
              PngEncoder encoder = PngEncoder();

              // decode original tile png to raw image
              Image image = decoder.decode(value.buffer.asUint8List()) ?? Image(width: 1, height: 1);
              // build [ImageGradient] from raw image
              imageGradient = ImageGradient(
                  image: image,
                  colorGradient: colorGradient,
                  step: step
              );

              // encode the build raw images from [ImageGradient] to png format
              pngList = List.generate(
                  imageGradient.imageList.length,
                      (index) => encoder.encode(imageGradient.imageList[index])
              );
              print("done");
            }
    );
  }
}