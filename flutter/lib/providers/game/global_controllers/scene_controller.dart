import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:ship_conquest/domain/immutable_collections/grid.dart';
import 'package:ship_conquest/domain/immutable_collections/utils/extend_grid.dart';
import 'package:ship_conquest/domain/island/utils.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/utils/distance.dart';
import 'package:ship_conquest/domain/utils/pulse.dart';
import '../../../domain/island/island.dart';
import '../../../domain/space/coordinate.dart';
import '../../../domain/space/position.dart';
import '../../../domain/horizon.dart';
import '../../../domain/tile/tile_state.dart';
import '../../../domain/tile/tiles_order.dart';
import '../../../utils/constants.dart';

///
/// Independent game related controller that holds [State] of
/// the old & new rendered voxels.
///
/// Mixin to the [ChangeNotifier] class, so widget's can
/// listen to changes to [State].
///
/// The [SceneController] handles the data that is used to build
/// the rendered scene by managing the [KnownIslands] & current
/// [Voxels] being rendered.
///
class SceneController with ChangeNotifier {
  late Grid<int, Island> _visitedIslands;
  late HorizonFn _horizonFn;
  // constructor
  SceneController();

  // output
  TilesOrder<Coordinate> get tiles => _getTiles();
  Sequence<Island> get visitedIslands => _visitedIslands.toSequence();
  Sequence<Island> get islands => _islands.toSequence();

  // variables
  Position _lastPos = const Position(x: double.infinity, y: double.infinity);
  Grid<int, Island> _islands = Grid.empty();
  Sequence<Coordinate> _newTiles = Sequence.empty();
  Sequence<Coordinate> _oldTiles = Sequence.empty();
  final HashMap<Coord2D, int> _newTilesMap = HashMap();
  HashMap<Coord2D, int> _oldTilesMap = HashMap();

  void load(Sequence<Island> islands, HorizonFn horizonFn) {
    _visitedIslands = Grid(data: { for(var island in islands.data) island.id : island });
    _horizonFn = horizonFn;
  }

  void updateIsland(Island island) {
    _islands = _islands.put(island.id, island);
    // update widgets
    notifyListeners();
  }

  void discoverIsland(Island island) {
    _visitedIslands = _visitedIslands.put(island.id, island);
  }

  Future<Sequence<Coordinate>> tryToGetScene(Position position, int sid) async {
    if (distance(position, _lastPos) <= 1.0) return Sequence.empty();

    return getScene(position, sid);
  }

  Future<Sequence<Coordinate>> getScene(Position position, int sid) async {
    final shouldFetch = _visitedIslands.any((value) => value.isCloseTo(position));

    // save & clear previous scene
    _savePreviousScene();

    // update position
    _lastPos = position;

    return shouldFetch ? fetchScene(position, sid) : buildEmptyScene(position);
  }

  Future<Sequence<Coordinate>> buildEmptyScene(Position position) async {
    // generate placeholder scene
    _generateWaterScene(position.toCoord2D());

    notifyListeners();
    return _newTiles;
  }

  Future<Sequence<Coordinate>> fetchScene(Position position, int sid) async {
    // fetch terrain tiles
    final coord = position.toCoord2D();
    await _fetchTerrainTiles(coord, sid);
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

  Future<void> _fetchTerrainTiles(Coord2D coordinate, int sid) async {
    // fetch tiles from services
    Horizon? horizon = await _horizonFn(coordinate, sid);
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