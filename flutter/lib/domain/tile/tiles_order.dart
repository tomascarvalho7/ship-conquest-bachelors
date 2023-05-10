import 'package:ship_conquest/domain/tile/tile_state.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';

import '../space/coord_2d.dart';

class TilesOrder<T> {
  final Sequence<T> tiles;
  final Map<Coord2D, TileState> tilesStates;
  // constructor
  TilesOrder({required this.tiles, required this.tilesStates});
}