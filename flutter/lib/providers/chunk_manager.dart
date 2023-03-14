import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/coord_2d.dart';
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

  final HashMap<Coord2D, int> tilesHM = HashMap();

  Offset _lastCoords = const Offset(double.infinity, double.infinity);

  // x -> y
  double distance(Offset x, Offset y) => sqrt(pow(y.dx - x.dx, 2) + pow(y.dy - x.dy, 2));

  bool manageChunks(Offset coordinates, ShipServices services) {
    if (distance(_lastCoords, coordinates) < tileSize / 2) return false;
    _lastCoords = coordinates;
    updateChunks(coordinates, services);
    return true;
  }

  Coordinate screenToIsometricChunk(Position position) {
    late final double widthHalf = tileSize / 2;
    late final double heightHalf = tileSize / 4;
    return Coordinate(
        x: -((position.y / heightHalf + (position.x / widthHalf)) / 2).floor(),
        y: -((position.y / heightHalf - (position.x / widthHalf)) / 2).floor(),
        z: -((position.y / heightHalf - (position.x / widthHalf)) / 2).floor()
    );
  }

  void generateInitialSquare(Coordinate coord) {
      for (int index = 0; index < chunkSize * chunkSize; index++) {
        int offsetX = coord.x;
        int offsetY = coord.y;
        int x = index % chunkSize;
        int y = (index / chunkSize).floor();
        tilesHM.putIfAbsent(Coord2D(x: x + offsetX, y: y + offsetY), () => tiles.length);
        tiles.add(Coordinate(x: x + offsetX, y: y + offsetY, z: 0));
      }
  }

  Future<void> generateChunk(Coordinate coordinate, ShipServices services) async {
      generateInitialSquare(coordinate);

      Chunk newChunk = await services.getNewChunk(chunkSize, coordinate);
      for(var tile in newChunk.tiles) {
        //print("tile ${tile.x} : ${tile.y}");
        int? index = tilesHM[Coord2D(x: tile.x, y: tile.y)];
        if(index != null) {
          tiles[index] = tile;
        }
      }
  }

  // update visible chunks
  void updateChunks(Offset coordinates, ShipServices services) {
    // clear visible chunks
    visibleChunks.clear();
    tiles.clear();
    tilesHM.clear();
    Coordinate coord = screenToIsometricChunk(Position(x: coordinates.dx, y: coordinates.dy));

    generateChunk(coord, services).then(
            (value) => notifyListeners() // notify consumers to rebuild widgets !
    );
  }
}