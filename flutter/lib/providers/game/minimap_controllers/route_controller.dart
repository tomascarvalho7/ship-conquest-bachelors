import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/path/path_points.dart';
import 'package:ship_conquest/domain/path/path_segment.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';

import '../../../domain/space/position.dart';

///
/// Minimap related controller that holds [State] of
/// the player's drawn ship path.
///
/// Mixin to the [ChangeNotifier] class, so widget's can
/// listen to changes to [State].
///
/// The [RouteController] stores and manages the player's
/// drawn path from one of the [hooks] starter positions to
/// any point in the map.
///
class RouteController with ChangeNotifier {
  // variables
  Sequence<Position> _hooks = Sequence.empty();
  int _startIndex = 0;
  PathPoints? _pathPoints;
  PathSegment? _pathSegment;
  Sequence<Coord2D> _routePoints = Sequence.empty();

  int get selectedShipIndex => _startIndex;
  PathPoints? get pathPoints => _pathPoints;
  PathSegment? get pathSegment => _pathSegment;

  // path builder
  Sequence<Coord2D> get routePoints => _routePoints;

  void setRoutePoints(Sequence<Coord2D> points) {
    _routePoints = points;
    notifyListeners();
  }

  void setupHooks(Sequence<Position> hooks) {
    _hooks = hooks;
    final path = pathPoints;
    if (path != null) {
      _updatePoints(points: PathPoints(start: hooks.get(_startIndex), mid: path.mid, end: path.end));
    }
  }

  // select starter node
  void selectMainNode(int startIndex) {
    _pathSegment = PathSegment.start;
    _startIndex = startIndex;
    _pathPoints = null;
  }

  void deselect() {
    _pathSegment = null;
  }

  void selectSecondaryNode(PathSegment segment) {
    _pathSegment = segment;
  }

  void moveNode(Position delta) {
    if (_pathSegment == null) return; // no nodes to move

    if (_pathSegment == PathSegment.start) {
      draw(_hooks.get(_startIndex), delta);
    } else if (_pathSegment == PathSegment.mid) {
      updateMid(delta);
    } else {
      updateEnd(delta);
    }
  }

  void draw(Position start, Position endDelta) {
    Position end = (_pathPoints?.end ?? start) + endDelta;
    Position mid = Position(
        x: (start.x + end.x) / 2,
        y: (start.y + end.y) / 2
    );
    // create path points
    _updatePoints(
        points: PathPoints(start: start, mid: mid, end: end)
    );
    notifyListeners(); // update widgets
  }

  void updateMid(Position mid) {
    PathPoints? path = pathPoints;

    if (path != null) {
      _updatePoints(
          points: PathPoints(start: path.start, mid: path.mid + mid, end: path.end)
      );
      notifyListeners(); // update widgets
    }
  }

  void updateEnd(Position end) {
    PathPoints? path = pathPoints;

    if (path != null) {
      _updatePoints(
          points: PathPoints(start: path.start, mid: path.mid, end: path.end + end)
      );
      notifyListeners(); // update widgets
    }
  }

  void confirm() {
    _routePoints = Sequence.empty(); // clear route
    _pathPoints = null; // clear path
    notifyListeners(); // update widgets
  }

  void cancel() {
    _routePoints = Sequence.empty(); // clear route
    _pathPoints = null; // clear path
    notifyListeners(); // update widgets
  }

  void _updatePoints({required PathPoints points}) {
    _pathPoints = PathPoints(start: points.start, mid: points.mid, end: points.end);
  }
}