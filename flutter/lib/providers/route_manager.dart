import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/path/path_points.dart';
import 'package:ship_conquest/domain/path/path_segment.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';

import '../domain/minimap.dart';
import '../domain/space/position.dart';

class RouteManager with ChangeNotifier {
  List<Position> _hooks = [];
  int? _startIndex;
  PathPoints? _pathPoints;
  PathSegment? _pathSegment;
  List<Coord2D> _routePoints = [];

  PathPoints? get pathPoints => _pathPoints;
  PathSegment? get pathSegment => _pathSegment;

  // path builder
  List<Coord2D> get routePoints => _routePoints;

  void setRoutePoints(List<Coord2D> points) {
    _routePoints = points;
    notifyListeners();
  }

  void setupHooks(List<Position> hooks, Minimap minimap) {
    _hooks = hooks;
    final index = _startIndex;
    final path = pathPoints;
    if (index != null && path != null) {
      _updatePoints(points: PathPoints(start: hooks[index], mid: path.mid, end: path.end), minimap: minimap);
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

  void moveNode(Minimap minimap, Position delta) {
    if (_pathSegment == null) return; // no nodes to move

    final index = _startIndex;
    if (_pathSegment == PathSegment.start && index != null) {
      draw(minimap, _hooks[index], delta);
    } else if (_pathSegment == PathSegment.mid) {
      updateMid(minimap, delta);
    } else {
      updateEnd(minimap, delta);
    }
  }

  void draw(Minimap minimap, Position start, Position endDelta) {
    Position end = (_pathPoints?.end ?? start) + endDelta;
    Position mid = Position(
        x: (start.x + end.x) / 2,
        y: (start.y + end.y) / 2
    );
    // create path points
    _updatePoints(
        points: PathPoints(start: start, mid: mid, end: end),
        minimap: minimap
    );
    notifyListeners(); // update widgets
  }

  void updateMid(Minimap minimap, Position mid) {
    PathPoints? path = pathPoints;

    if (path != null) {
      _updatePoints(
          points: PathPoints(start: path.start, mid: path.mid + mid, end: path.end),
          minimap: minimap
      );
      notifyListeners(); // update widgets
    }
  }

  void updateEnd(Minimap minimap, Position end) {
    PathPoints? path = pathPoints;

    if (path != null) {
      _updatePoints(
          points: PathPoints(start: path.start, mid: path.mid, end: path.end + end),
          minimap: minimap
      );
      notifyListeners(); // update widgets
    }
  }

  void confirm() {
    _routePoints = []; // clear route
    _pathPoints = null; // clear path
    notifyListeners(); // update widgets
  }

  void cancel() {
    _routePoints = []; // clear route
    _pathPoints = null; // clear path
    notifyListeners(); // update widgets
  }

  void _updatePoints({required PathPoints points, required Minimap minimap}) {
    _pathPoints = PathPoints(start: points.start, mid: points.mid, end: points.end);
  }
}