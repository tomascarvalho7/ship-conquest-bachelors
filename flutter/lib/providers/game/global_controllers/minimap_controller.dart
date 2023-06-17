
import 'package:flutter/material.dart';
import 'package:ship_conquest/domain/game/minimap.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/space/coordinate.dart';

///
/// Independent game related controller that holds [State] of
/// the player's minimap.
///
/// Mixin to the [ChangeNotifier] class, so widget's can
/// listen to changes to [State].
///
/// The [MinimapController] stores and manages the player's
/// minimap. The [Minimap] is a grid of [Pixels] with the visited
/// [Voxel] data stored.
///
class MinimapController with ChangeNotifier {
  late Minimap minimap;
  MinimapController();

  /// Load the minimap
  load(Minimap minimap) {
    this.minimap = minimap;
  }

  /// Update the minimap with the new Sequence [tiles].
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