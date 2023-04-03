import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';
import 'package:ship_conquest/domain/utils/pulse.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';

import '../domain/space/tile_list.dart';
import '../domain/space/coordinate.dart';
import '../domain/space/position.dart';

class TileManager with ChangeNotifier {
  final int chunkSize;
  final double tileSize;
  TileManager({required this.chunkSize, required this.tileSize});

  // variables
  final List<Coordinate> tiles = List.empty(growable: true);
  final HashMap<Coord2D, int> _tilesHM = HashMap();
  Position _lastCoords = const Position(x: double.infinity, y: double.infinity);

  Future<bool> lookForTiles(Position position, ShipServices services) async {
    if (_distance(_lastCoords, position) < tileSize * 2) return false;
    _lastCoords = position;
    await _updateTiles(position, services);
    return true;
  }

  // a -> b
  double _distance(Position a, Position b) => sqrt(pow(b.x - a.x, 2) + pow(b.y - a.y, 2));

  Coordinate _screenToIsometricCoord(Position position) {
    late final double widthHalf = tileSize / 2;
    late final double heightHalf = tileSize / 4;
    return Coordinate(
        x: -((position.y / heightHalf + (position.x / widthHalf)) / 2).floor(),
        y: -((position.y / heightHalf - (position.x / widthHalf)) / 2).floor(),
        z: -((position.y / heightHalf - (position.x / widthHalf)) / 2).floor()
    );
  }

  // update visible tiles
  Future<void> _updateTiles(Position position, ShipServices services) async {
    // clear tiles
    tiles.clear();
    _tilesHM.clear();
    Coordinate coord = _screenToIsometricCoord(position);

    // generate placeholder water tiles
    _generateWaterTiles(coord);
    notifyListeners();
    // fetch terrain tiles
    await _fetchTerrainTiles(coord, services);
    notifyListeners();
    return;
  }

  void _generateWaterTiles(Coordinate origin) {
      pulse(
          radius: chunkSize,
          block: (coord) {
            final x = origin.x + coord.x;
            final y = origin.y + coord.y;
            _tilesHM.putIfAbsent(Coord2D(x: x, y: y), () => tiles.length);
            tiles.add(Coordinate(x: x, y: y, z: 0));
          }
      );
  }

  Future<void> _fetchTerrainTiles(Coordinate coordinate, ShipServices services) async {
      // fetch tiles from services
      TileList newChunk = await services.getNewChunk(chunkSize, coordinate);
      // update fetched tiles from existing ones
      for(var tile in newChunk.tiles) {
        int? index = _tilesHM[Coord2D(x: tile.x, y: tile.y)];
        if(index != null) {
          tiles[index] = tile;
        }
      }
  }
}