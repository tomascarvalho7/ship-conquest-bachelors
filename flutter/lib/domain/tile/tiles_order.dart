import 'package:ship_conquest/domain/space/coord_2d.dart';
import 'package:ship_conquest/domain/tile/tile_state.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';

/// Represents the order of the game's tiles by a [Sequence] of tiles and a map
/// of [Coord2D] to [TileState].
class TilesOrder<T> {
  final Sequence<T> tiles;
  final Map<Coord2D, TileState> tilesStates;
  // constructor
  TilesOrder({required this.tiles, required this.tilesStates});
}