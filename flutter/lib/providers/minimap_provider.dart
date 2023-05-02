import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../domain/color/color_gradient.dart';
import '../domain/space/coordinate.dart';
import '../domain/minimap.dart';
import '../domain/space/sequence.dart';

class MinimapProvider with ChangeNotifier {
  Minimap minimap;
  MinimapProvider({required this.minimap});

  update(Sequence<Coordinate> tiles) {
    final length = tiles.length;
    for(int i = 0; i < length; i++) {
      final coord = tiles.get(i);
      // add pixel
      final height = minimap.get(x: coord.x, y: coord.y);
      if (height == null || coord.z > height) {
        minimap.add(x: coord.x, y: coord.y, height: coord.z);
      }
    }
    notifyListeners();
  }
}