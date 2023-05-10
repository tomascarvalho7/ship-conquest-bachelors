import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/path/path_points.dart';
import 'package:ship_conquest/domain/path/path_segment.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';

import '../../../domain/minimap.dart';
import '../../../domain/space/position.dart';

class RouteController with ChangeNotifier {
  Sequence<Position> _hooks = Sequence.empty();
  int? _startIndex;
  PathPoints? _pathPoints;
  PathSegment? _pathSegment;
  Sequence<Coord2D> _routePoints = Sequence.empty();

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
    final index = _startIndex;
    final path = pathPoints;
    if (index != null && path != null) {
      _updatePoints(points: PathPoints(start: hooks.get(index), mid: path.mid, end: path.end));
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

    final index = _startIndex;
    if (_pathSegment == PathSegment.start && index != null) {
      draw(_hooks.get(index), delta);
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