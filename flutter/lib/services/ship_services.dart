import 'package:ship_conquest/domain/tile_list.dart';
import 'package:ship_conquest/domain/coordinate.dart';

abstract class ShipServices {
  Future<TileList> getNewChunk(int chunkSize, Coordinate coordinates);
}