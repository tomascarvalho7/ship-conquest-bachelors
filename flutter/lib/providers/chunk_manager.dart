import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/services/ship_services.dart';

import '../domain/chunk.dart';
import '../domain/coordinate.dart';
import '../domain/position.dart';

class ChunkManager with ChangeNotifier {
  final double viewDst = 750.0;
  final int chunkSize;
  final double tileSize;
  late final int chunksVisibleInViewDst = 1;
  ChunkManager({required this.chunkSize, required this.tileSize});

  final HashMap<Coordinate, Chunk> chunks = HashMap();
  final List<Chunk> visibleChunks = List.empty(growable: true);

  Offset _lastCoords = const Offset(double.infinity, double.infinity);

  // x -> y
  double distance(Offset x, Offset y) => sqrt(pow(y.dx - x.dx, 2) + pow(y.dy - x.dy, 2));

  bool manageChunks(Offset coordinates, ShipServices services) {
    if (distance(_lastCoords, coordinates) < chunkSize * tileSize / 2) return false;
    _lastCoords = coordinates;
    updateChunks(coordinates, services);
    return true;
  }

  // move later
  late final double widthHalf = chunkSize * tileSize / 2;
  late final double heightHalf = chunkSize * tileSize / 4;
  Coordinate screenToIsometricChunk(Position position) {
    return Coordinate(
        x: -((position.y / heightHalf + (position.x / widthHalf)) / 2).floor(),
        y: -((position.y / heightHalf - (position.x / widthHalf)) / 2).floor(),
        z: -((position.y / heightHalf - (position.x / widthHalf)) / 2).floor() // equal to y, maybe change
    );
  }

  // update visible chunks
  Future<void> updateChunks(Offset coordinates, ShipServices services) async {
    // clear visible chunks
    visibleChunks.clear();

    Coordinate coord = screenToIsometricChunk(Position(x: coordinates.dx, y: coordinates.dy));
    for(int y = -chunksVisibleInViewDst; y <= chunksVisibleInViewDst; y++) {
      for(int x = -chunksVisibleInViewDst; x <= chunksVisibleInViewDst; x++) {
        Coordinate currentCoord = Coordinate(
            x: coord.x + x,
            y: coord.y + y,
            z: coord.z + coord.y
        );

        // add chunk from cache or if null create new chunk
        visibleChunks.add(chunks[currentCoord] ?? await services.getNewChunk(chunkSize, currentCoord));
      }
    }

    // notify consumers to rebuild widgets !
    notifyListeners();
  }
}