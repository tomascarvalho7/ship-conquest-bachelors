import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:ship_conquest/domain/immutable_collections/grid.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/utils/distance.dart';
import 'package:ship_conquest/domain/utils/pulse.dart';
import '../../../domain/island/island.dart';
import '../../../domain/ship/ship.dart';
import '../../../domain/space/coordinate.dart';
import '../../../domain/space/position.dart';
import '../../../domain/horizon.dart';
import '../../../domain/tile/tile_state.dart';
import '../../../domain/tile/tiles_order.dart';
import '../../../utils/constants.dart';

class SceneController with ChangeNotifier {
  late Grid<int, Island> _visitedIslands;
  // constructor
  SceneController();

  // output
  TilesOrder<Coordinate> get tiles => _getTiles();
  Sequence<Island> get visitedIslands => _visitedIslands.toSequence();
  Sequence<Island> get islands => _islands.toSequence();

  // variables
  Grid<int, Position> _lastPos = Grid.empty();
  Grid<int, Island> _islands = Grid.empty();
  Sequence<Coordinate> _newTiles = Sequence.empty();
  Sequence<Coordinate> _oldTiles = Sequence.empty();
  final HashMap<Coord2D, int> _newTilesMap = HashMap();
  HashMap<Coord2D, int> _oldTilesMap = HashMap();

  void load(Sequence<Island> islands) {
    _visitedIslands = Grid(data: { for(var island in islands.data) island.id : island });
  }

  void updateIsland(Island island) {
    _islands = _islands.put(island.id, island);
    // update widgets
    notifyListeners();
  }

  void discoverIsland(Island island) {
    _visitedIslands = _visitedIslands.put(island.id, island);
  }

  Position _getOrCreate(int id) {
    final pos = _lastPos.getOrNull(id) ?? const Position(x: double.infinity, y: double.infinity);
    if (_lastPos.getOrNull(id) == null) _lastPos = _lastPos.put(id, pos);
    return pos;
  }

  Future<Sequence<Coordinate>> tryToGetScene(Position position, int sid, HorizonFn fetchHorizon) async {
    if (distance(position, _getOrCreate(sid)) <= 1.0) return Sequence.empty();
    // save & clear previous scene
    _savePreviousScene();
    return getScene(position, sid, fetchHorizon);
  }

  Future<Sequence<Coordinate>> getMultipleScenes(Sequence<Ship> fleet, HorizonFn fetchHorizon) async {
    var result = Sequence<Coordinate>.empty();

    for (var ship in fleet) {
      final pos = ship.getPosition(globalScale);
      if (distance(pos, _getOrCreate(ship.sid)) > 1.0) {
        // save & clear previous scene
        if (result.isEmpty) _savePreviousScene();
        result = result + await getScene(pos, ship.sid, fetchHorizon);
      }
    }

    return result;
  }

  Future<Sequence<Coordinate>> getScene(Position position, int sid, HorizonFn fetchHorizon) async {
    final shouldFetch = _visitedIslands.any((value) => value.isCloseTo(position));

    // update position
    _lastPos = _lastPos.put(sid, position);

    return shouldFetch ? fetchScene(position, sid, fetchHorizon) : buildEmptyScene(position);
  }

  Future<Sequence<Coordinate>> buildEmptyScene(Position position) async {
    // generate placeholder scene
    _generateWaterScene(position.toCoord2D());

    notifyListeners();
    return _newTiles;
  }

  Future<Sequence<Coordinate>> fetchScene(Position position, int sid, HorizonFn fetchHorizon) async {
    // fetch terrain tiles
    final coord = position.toCoord2D();
    await _fetchTerrainTiles(coord, sid, fetchHorizon);
    // generate placeholder scene
    _generateWaterScene(coord);

    notifyListeners();
    return _newTiles;
  }

  void _savePreviousScene() {
    // newTiles turn into oldTiles
    _oldTiles = _newTiles;
    _oldTilesMap = HashMap.from(_newTilesMap);
    // clear new tiles
    _newTiles = Sequence.empty();
    _newTilesMap.clear();
    _islands = Grid.empty();
  }

  void _generateWaterScene(Coord2D origin) {
    pulse(
        radius: chunkSize,
        block: (coord) {
          final x = origin.x + coord.x;
          final y = origin.y + coord.y;
          final pos = Coord2D(x: x, y: y);
          if (_newTilesMap[pos] == null) {
            _newTilesMap[pos] = _newTiles.length;
            _newTiles = _newTiles.put(Coordinate(x: x, y: y, z: 0));
          }
        }
    );
  }

  Future<void> _fetchTerrainTiles(Coord2D coordinate, int sid, HorizonFn fetchHorizon) async {
    // fetch tiles from services
    Horizon? horizon = await fetchHorizon(coordinate, sid);
    if (horizon == null) return;
    // update fetched tiles from existing ones
    for(var tile in horizon.tiles) {
      _newTilesMap.putIfAbsent(Coord2D(x: tile.x, y: tile.y), () => _newTiles.length);
      _newTiles = _newTiles.put(tile);
    }
    for(var island in horizon.islands) {
      _islands = _islands.put(island.id, island);
    }
  }

  Sequence<Coordinate> _buildGlobalTiles() {
    final oldTiles = List<Coordinate>.empty(growable: true);
    for(var index = 0; index < _oldTiles.length; index++) {
      final tile = _oldTiles.get(index);
      final coord = Coord2D(x: tile.x, y: tile.y);
      if (_newTilesMap[coord] == null) {
        oldTiles.add(tile);
      }
    }
    final list = [...oldTiles, ..._newTiles.data];
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

typedef HorizonFn = Future<Horizon?> Function(Coord2D coordinate, int sid);