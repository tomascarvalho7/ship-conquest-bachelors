import 'package:flutter/cupertino.dart';

import '../../../domain/space/coordinate.dart';
import '../../../domain/minimap.dart';
import '../../../domain/immutable_collections/sequence.dart';

class MinimapController with ChangeNotifier {
  late Minimap minimap;
  MinimapController();

  load(Minimap minimap) {
    this.minimap = minimap;
  }

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