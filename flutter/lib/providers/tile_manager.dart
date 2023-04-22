import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';
import 'package:ship_conquest/domain/space/sequence.dart';
import 'package:ship_conquest/domain/utils/pulse.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';

import '../domain/space/coordinate.dart';
import '../domain/space/position.dart';
import '../domain/tile/tile_list.dart';
import '../domain/tile/tile_state.dart';
import '../domain/tile/tiles_order.dart';

class TileManager with ChangeNotifier {
  final int chunkSize;
  final double tileSize;
  // constructor
  TileManager({required this.chunkSize, required this.tileSize});

  // output
  TilesOrder<Coordinate> get tiles => _getTiles();

  // variables
  Sequence<Coordinate> _newTiles = Sequence.empty();
  Sequence<Coordinate> _oldTiles = Sequence.empty();
  final HashMap<Coord2D, int> _newTilesMap = HashMap();
  HashMap<Coord2D, int> _oldTilesMap = HashMap();

  Future<Sequence<Coordinate>> lookForTiles(Position position, ShipServices services) async {
    await _updateTiles(Coord2D(x: position.x.round(), y: position.y.round()), services);
    return _newTiles;
  }

  // update visible tiles
  Future<void> _updateTiles(Coord2D coord, ShipServices services) async {
    // newTiles turn into oldTiles
    _oldTiles = _newTiles;
    _oldTilesMap = HashMap.from(_newTilesMap);
    // clear new tiles
    _newTiles = Sequence(data: []);
    _newTilesMap.clear();

    // generate placeholder water tiles
    _generateWaterTiles(coord);
    // fetch terrain tiles
    await _fetchTerrainTiles(coord, services);
    notifyListeners();
    return;
  }

  void _generateWaterTiles(Coord2D origin) {
      pulse(
          radius: chunkSize,
          block: (coord) {
            final x = origin.x + coord.x;
            final y = origin.y + coord.y;
            _newTilesMap.putIfAbsent(Coord2D(x: x, y: y), () => _newTiles.length);
            _newTiles = _newTiles.put(Coordinate(x: x, y: y, z: 0));
          }
      );
  }

  Future<void> _fetchTerrainTiles(Coord2D coordinate, ShipServices services) async {
    // fetch tiles from services
    TileList newChunk = await services.getNewChunk(chunkSize, coordinate);
    // update fetched tiles from existing ones
    for(var tile in newChunk.tiles) {
      int? index = _newTilesMap[Coord2D(x: tile.x, y: tile.y)];
      if(index != null) _newTiles = _newTiles.replace(index, tile);
    }
  }

  Sequence<Coordinate> _buildGlobalTiles() {
    final list = [..._oldTiles.data, ..._newTiles.data];
    mergeSort(
        list,
        compare: (a, b) => (a.y - b.y) + ((a.x - b.x) / 2).round()
    );
    return Sequence(data: list);
  }

  TilesOrder<Coordinate> _getTiles() {
    final globalTiles = _buildGlobalTiles();

    final tilesState = HashMap<Coord2D, TileState>();
    final length = globalTiles.length;
    for(var i = 0; i < length; i++) {
      final tile = globalTiles.get(i);
      final coord = Coord2D(x: tile.x, y: tile.y);

      int? indexNew = _newTilesMap[coord];
      int? indexOld = _oldTilesMap[coord];
      if (indexNew != null && indexOld != null) tilesState[coord] = TileState.neutral;
      else if (indexNew != null) tilesState[coord] = TileState.fresh;
      else if (indexOld != null) tilesState[coord] = TileState.dry;
    }

    return TilesOrder(tiles: globalTiles, tilesStates: tilesState);
  }
}