import 'dart:ui' as ui;
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ship_conquest/domain/color/color_gradient.dart';
import 'package:ship_conquest/domain/game/minimap.dart';
import 'package:ship_conquest/utils/constants.dart';
import 'package:ship_conquest/widgets/canvas/image_painter.dart';


/// Builds the minimap by painting the tiles in their respective [Painter].
class MinimapView extends StatelessWidget {
  final Minimap minimap;
  final ColorGradient gradient;
  final Color background = const Color.fromRGBO(0, 0, 0, 0.2);
  final Widget? child;
  const MinimapView({super.key, required this.minimap, required this.gradient, this.child});

  @override
  Widget build(BuildContext context) =>
      loadMinimap(minimap);

  Widget loadMinimap(Minimap minimap) {
    if (minimap.length == 0) return loading();

    return FutureBuilder<ui.Image>(
        future: _generateMinimapTexture(minimap),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return minimapRender(snapshot.data!, minimap.length);
          } else {
            return loading();
          }
        }
    );
  }


  Widget minimapRender(ui.Image img, int size) =>
      CustomPaint(
          painter: ImagePainter(
              image: img,
              size: minimapSize.round(),
              length: size
          ),
          child: child,
      );

  Widget loading() =>
      const SizedBox(
        width: minimapSize,
        height: minimapSize,
        child: CircularProgressIndicator(),
      );

  Future<ui.Image> _generateMinimapTexture(Minimap minimap) async {
    final int size = minimap.length;
    final completer = Completer<ui.Image>();

    Int32List pixels = Int32List(size * size);

    for(var x = 0; x < size; x++) {
      for(var y = 0; y < size; y++) {
        int index = y * size + x;
        final height = minimap.get(x: x, y: y);
        Color color = height != null ? gradient.get(height) : background;

        pixels[index] = color.value;
      }
    }

    ui.decodeImageFromPixels(
        pixels.buffer.asUint8List(),
        size,
        size,
        ui.PixelFormat.bgra8888,
            (ui.Image result) {
              completer.complete(result);
            }
    );

    return completer.future;
  }
}