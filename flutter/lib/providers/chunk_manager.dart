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
  final List<Coordinate> tiles = List.empty(growable: true);

  final HashMap<String, int> tilesHM = HashMap();

  Offset _lastCoords = const Offset(double.infinity, double.infinity);

  // x -> y
  double distance(Offset x, Offset y) => sqrt(pow(y.dx - x.dx, 2) + pow(y.dy - x.dy, 2));

  bool manageChunks(Offset coordinates, ShipServices services) {
    if (distance(_lastCoords, coordinates) < chunkSize * tileSize / 2) return false;
    _lastCoords = coordinates;
    updateChunks(coordinates, services);
    return true;
  }

  Coordinate screenToIsometricChunk(Position position) {
    late final double widthHalf = chunkSize * tileSize / 2;
    late final double heightHalf = chunkSize * tileSize / 4;
    return Coordinate(
        x: -((position.y / heightHalf + (position.x / widthHalf)) / 2).floor(),
        y: -((position.y / heightHalf - (position.x / widthHalf)) / 2).floor(),
        z: -((position.y / heightHalf - (position.x / widthHalf)) / 2).floor()
    );
  }

  void generateInitialSquare(Offset coordinates) {
    Coordinate coord = screenToIsometricChunk(Position(x: coordinates.dx, y: coordinates.dy));
      Coordinate currentCoord = Coordinate(
          x: coord.x,
          y: coord.y,
          z: coord.z + coord.y
      );

      for (int index = 0; index < chunkSize * chunkSize; index++) {
        int offsetX = currentCoord.x * chunkSize;
        int offsetY = currentCoord.y * chunkSize;
        int x = index % chunkSize;
        int y = (index / chunkSize).floor();

        tilesHM.putIfAbsent("$x:$y", () => tiles.length);

        tiles.add(Coordinate(x: x + offsetX, y: y + offsetY, z: 0));
      }
  }

  Future<Chunk> generateChunk(Offset coordinates, ShipServices services) async {
      generateInitialSquare(coordinates);

      Coordinate coords = Coordinate(x: coordinates.dx.round(), y: coordinates.dy.round(), z: 0);
      Chunk newChunk = await services.getNewChunk(chunkSize, coords);
      for(var tile in newChunk.tiles) {
        int? index = tilesHM["${tile.x}:${tile.y}"];
        if(index != null) {
          tiles[index] = tile;
        }
      }
      return newChunk;
  }

  // update visible chunks
  Future<void> updateChunks(Offset coordinates, ShipServices services) async {
    // clear visible chunks
    visibleChunks.clear();
    tiles.clear();
    Coordinate coord = screenToIsometricChunk(Position(x: coordinates.dx, y: coordinates.dy));
      Coordinate currentCoord = Coordinate(
          x: coord.x,
          y: coord.y,
          z: coord.z + coord.y
      );

      // get chunk from cache or if null create new chunk
      Chunk chunk = chunks[currentCoord] ?? await generateChunk(coordinates, services);
      // add chunk
      visibleChunks.add(chunk);

      // build list of tiles
      for(int i = 0; i < chunk.tiles.length; i++) {
        final tile = chunk.tiles[i];
        tiles.add(tile);
      }

    // notify consumers to rebuild widgets !
    notifyListeners();
  }
}