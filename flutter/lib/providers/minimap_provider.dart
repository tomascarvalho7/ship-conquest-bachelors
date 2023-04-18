import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../domain/color/color_gradient.dart';
import '../domain/space/coordinate.dart';
import '../domain/minimap.dart';
import '../domain/space/sequence.dart';

class MinimapProvider with ChangeNotifier {
  late Minimap minimap = Minimap(length: 0, pixels: HashMap());

  init(Minimap newMinimap) => minimap = newMinimap;

  update(Sequence<Coordinate> tiles, ColorGradient colorGradient) {
    final length = tiles.length;
    for(int i = 0; i < length; i++) {
      final coord = tiles.get(i);
      // add pixel
      minimap.add(x: coord.x, y: coord.y, color: colorGradient.get(coord.z));
    }
    notifyListeners();
  }
}