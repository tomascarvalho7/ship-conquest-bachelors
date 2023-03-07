import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/position.dart';

class Camera with ChangeNotifier {
  final Position origin;
  Camera({required this.origin});

  late Offset _coordinates = const Offset(0, 0);
  double _baseScaleFactor = 1.0;
  double _scaleFactor = 1.0;

  Offset get coordinates => _coordinates;
  Offset get centerCoordinates => _coordinates + Offset(origin.x, origin.y);
  double get scaleFactor => _scaleFactor;
  double get baseScaleFactor => _baseScaleFactor;

  void onUpdate(double size, Offset movementOffset) {
    _scaleFactor = _baseScaleFactor * size;
    _coordinates = Offset(
        _coordinates.dx + movementOffset.dx,
        _coordinates.dy + movementOffset.dy
    );
    notifyListeners();
  }

  void onStart() {
    _baseScaleFactor = _scaleFactor;
  }
}