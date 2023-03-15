import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/coord_2d.dart';
import 'package:ship_conquest/services/ship_services.dart';

import '../domain/tile_list.dart';
import '../domain/coordinate.dart';
import '../domain/position.dart';

class TileManager with ChangeNotifier {
  final int chunkSize;
  final double tileSize;
  TileManager({required this.chunkSize, required this.tileSize});

  final List<Coordinate> tiles = List.empty(growable: true);
  final HashMap<Coord2D, int> tilesHM = HashMap();

  Offset _lastCoords = const Offset(double.infinity, double.infinity);

  // x -> y
  double distance(Offset x, Offset y) => sqrt(pow(y.dx - x.dx, 2) + pow(y.dy - x.dy, 2));

  bool manageChunks(Offset coordinates, ShipServices services) {
    if (distance(_lastCoords, coordinates) < tileSize * 2) return false;
    _lastCoords = coordinates;
    updateTiles(coordinates, services);
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

  // update visible tiles
  void updateTiles(Offset coordinates, ShipServices services) {
    // clear tiles
    tiles.clear();
    tilesHM.clear();
    Coordinate coord = screenToIsometricChunk(Position(x: coordinates.dx, y: coordinates.dy));

    // fetch terrain tiles
    fetchTerrainTiles(coord, services).then(
            (value) => notifyListeners() // notify consumers to rebuild widgets !
    );

    // generate placeholder water tiles
    generateWaterTiles(coord);
  }

  void generateWaterTiles(Coordinate coord) {
      for (int index = 0; index < chunkSize * chunkSize; index++) {
        int offsetX = coord.x;
        int offsetY = coord.y;
        int x = index % chunkSize;
        int y = (index / chunkSize).floor();
        tilesHM.putIfAbsent(Coord2D(x: x + offsetX, y: y + offsetY), () => tiles.length);
        tiles.add(Coordinate(x: x + offsetX, y: y + offsetY, z: 0));
      }
  }

  Future<void> fetchTerrainTiles(Coordinate coordinate, ShipServices services) async {
      // fetch tiles from services
      TileList newChunk = await services.getNewChunk(chunkSize, coordinate);
      // update fetched tiles from existing ones
      for(var tile in newChunk.tiles) {
        int? index = tilesHM[Coord2D(x: tile.x, y: tile.y)];
        if(index != null) {
          tiles[index] = tile;
        }
      }
  }
}