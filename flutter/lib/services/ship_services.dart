import 'package:ship_conquest/domain/chunk.dart';
import 'package:ship_conquest/domain/coordinate.dart';

abstract class ShipServices {
  Future<Chunk> getNewChunk(int chunkSize, Coordinate coordinates);
}