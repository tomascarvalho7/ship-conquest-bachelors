import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/path/path_points.dart';
import 'package:ship_conquest/domain/path/path_segment.dart';

import '../domain/space/position.dart';

class PathManager with ChangeNotifier {
  Position? _startPoint;
  PathPoints? _pathPoints;
  PathSegment? _pathSegment;

  PathPoints? get pathPoints => _pathPoints;
  PathSegment? get pathSegment => _pathSegment;

  // select starter node
  void selectMainNode(Position start) {
    _pathSegment = PathSegment.start;
    _startPoint = start;
  }

  void deselect() {
    _startPoint = null;
    _pathSegment = null;
  }

  void selectSecondaryNode(PathSegment segment) {
    _pathSegment = segment;
  }

  void moveNode(Position position) {
    if (_pathSegment == null) return; // no nodes to move

    if (_pathSegment == PathSegment.start) {
      draw(_startPoint!, position);
    } else if (_pathSegment == PathSegment.mid) {
      updateMid(position);
    } else {
      updateEnd(position);
    }
  }

  void draw(Position start, Position end) {
    Position mid = Position(
        x: (start.x + end.x) / 2,
        y: (start.y + end.y) / 2
    );
    // create path points
    _pathPoints = PathPoints(start: start, mid: mid, end: end);
    notifyListeners(); // update widgets
  }

  void updateMid(Position mid) {
    PathPoints? path = pathPoints;

    if (path != null) {
      _pathPoints = PathPoints(start: path.start, mid: mid, end: path.end);
      notifyListeners(); // update widgets
    }
  }

  void updateEnd(Position end) {
    PathPoints? path = pathPoints;

    if (path != null) {
      _pathPoints = PathPoints(start: path.start, mid: path.mid, end: end);
      notifyListeners(); // update widgets
    }
  }

  void confirm() {
    // TODO
  }

  void cancel() {
    _pathPoints = null; // clear path
    notifyListeners(); // update widgets
  }
}