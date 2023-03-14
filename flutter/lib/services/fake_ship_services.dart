import 'dart:math';

import 'package:ship_conquest/domain/chunk.dart';
import 'package:ship_conquest/domain/coordinate.dart';

import 'ship_services.dart';

class FakeShipServices extends ShipServices {
  @override
  Future<Chunk> getNewChunk(int chunkSize, Coordinate coordinates) {
    Random rnd = Random();
    int offsetX = coordinates.x;
    int offsetY = coordinates.y;

    return Future(() => Chunk(
        size: chunkSize,
        coordinates: coordinates,
        tiles: List.generate(chunkSize * chunkSize, (index) {
          int x = index % chunkSize;
          int y = (index / chunkSize).floor();
          int z = rndToCoordinate(rnd.nextDouble());
          return Coordinate(x: x + offsetX, y: y + offsetY, z: z);
        })));
  }
}

int rndToCoordinate(double value) {
  return ((value * 99) % 99).round();
}
