import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../domain/color_gradient.dart';
import '../domain/coordinate.dart';
import '../domain/minimap.dart';

class MinimapProvider with ChangeNotifier {
  late Minimap minimap = Minimap(length: 0, pixels: HashMap());

  init(Minimap newMinimap) => minimap = newMinimap;

  update(List<Coordinate> tiles, ColorGradient colorGradient) {
    final length = tiles.length;
    for(int i = 0; i < length; i++) {
      final coord = tiles[i];
      // add pixel
      minimap.add(x: coord.x, y: coord.y, color: colorGradient.get(coord.z));
    }
    notifyListeners();
  }
}