import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/space/position.dart';

///
/// Independent game related controller that holds [State] of
/// the player's camera position.
///
/// Mixin to the [ChangeNotifier] class, so widget's can
/// listen to changes to [State].
///
/// The [CameraController] stores and manages the player's
/// [Camera] 2D position.
///
class CameraController with ChangeNotifier {
  late Position _coordinates = const Position(x: 0, y: 0);
  double _baseScaleFactor = 1.0;
  double _scaleFactor = 1.0;

  Position get coordinates => _coordinates;
  double get scaleFactor => _scaleFactor;
  double get baseScaleFactor => _baseScaleFactor;

  /// Sets the focus of the camera to [position] and notifies the listening widgets.
  void setFocusAndUpdate(Position position, {double scale = 1.0}) {
    setFocus(position, scale: scale);
    notifyListeners();
  }

  /// Sets the focus of the camera to [position].
  void setFocus(Position position, {double scale = 1.0}) {
    _coordinates = position;
    _scaleFactor = scale;
  }

  /// Handles the camera updates
  ///
  /// [size] handles zooming in or out;
  /// [movementOffset] handles camera panning.
  void onUpdate(double size, Offset movementOffset) {
    _scaleFactor = _baseScaleFactor * size;
    _coordinates = Position(
        x: _coordinates.x + movementOffset.dx / _scaleFactor,
        y: _coordinates.y + movementOffset.dy / _scaleFactor
    );
    notifyListeners();
  }

  /// Resets the scale factor
  void onStart() {
    _baseScaleFactor = _scaleFactor;
  }
}