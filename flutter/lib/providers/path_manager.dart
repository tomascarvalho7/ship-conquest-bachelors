import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/space/pathPoints.dart';

import '../domain/space/position.dart';

class PathManager with ChangeNotifier {
  // curve starts being null
  PathPoints? _pathPoints;

  PathPoints? get pathPoints => _pathPoints;

  void draw(Position start, Position newEnd) {
    Position end = (_pathPoints?.end ?? const Position(x: 0, y: 0)) + newEnd;
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
      _pathPoints = PathPoints(start: path.start, mid: path.mid + mid, end: path.end);
      notifyListeners(); // update widgets
    }
  }

  void updateEnd(Position end) {
    PathPoints? path = pathPoints;

    if (path != null) {
      _pathPoints = PathPoints(start: path.start, mid: path.mid, end: path.end + end);
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