import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/space/position.dart';

class Camera with ChangeNotifier {
  late Position _coordinates = const Position(x: 0, y: 0);
  double _baseScaleFactor = 1.0;
  double _scaleFactor = 1.0;

  Position get coordinates => _coordinates;
  double get scaleFactor => _scaleFactor;
  double get baseScaleFactor => _baseScaleFactor;

  void setFocus(Position position) {
    _coordinates = position;
  }

  void onUpdate(double size, Offset movementOffset) {
    _scaleFactor = _baseScaleFactor * size;
    _coordinates = Position(
        x: _coordinates.x + movementOffset.dx / _scaleFactor,
        y: _coordinates.y + movementOffset.dy / _scaleFactor
    );
    notifyListeners();
  }

  void onStart() {
    _baseScaleFactor = _scaleFactor;
  }
}