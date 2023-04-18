import 'package:ship_conquest/domain/space/tile_state.dart';
import 'package:ship_conquest/domain/space/sequence.dart';

import 'coord_2d.dart';

class TilesOrder<T> {
  final Sequence<T> tiles;
  final Map<Coord2D, TileState> tilesStates;
  // constructor
  TilesOrder({required this.tiles, required this.tilesStates});
}