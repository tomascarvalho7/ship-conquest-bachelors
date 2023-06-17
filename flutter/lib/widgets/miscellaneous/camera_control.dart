import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/camera_controller.dart';
import 'package:vector_math/vector_math_64.dart';


/// Controls the game's camera actions.
/// Makes direct use of a [GestureDetector] to act with [CameraController].
///
/// - [background] the background color
/// - [child] the child to be rendered under this widget in the tree
class CameraControl extends StatelessWidget {
  final Color background;
  final Widget child;
  // constructor
  const CameraControl({
    super.key,
    required this.background,
    required this.child,
  });

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(
          builder: (_, constraints) =>
              Consumer<CameraController>(
                builder: (_, camera, __) =>
                    GestureDetector(
                        onTapDown: (details) => onTap(camera, details, constraints),
                        onScaleStart: (details) => onStart(camera, details, constraints),
                        onScaleUpdate: (details) => onUpdate(camera, details),
                        onScaleEnd: onEnd,
                        child: Container(
                            color: background,
                            width: double.infinity,
                            height: double.infinity,
                            child: Transform(
                                transform: Matrix4.compose(
                                    Vector3(
                                        constraints.maxWidth / 2 + camera.coordinates.x * camera.scaleFactor,
                                        constraints.maxHeight / 2 + camera.coordinates.y * camera.scaleFactor,
                                        0.0
                                    ),
                                    Quaternion.identity(),
                                    Vector3.all(camera.scaleFactor)
                                ),
                                child: child
                            )
                        )
                    ),
              )
      );

  // Gesture detector control helper functions

  /// Ignore a simple tap
  void onTap(CameraController camera, TapDownDetails details, BoxConstraints constraints) { /* do nothing */ }

  /// Act with the camera on the start
  void onStart(CameraController camera, ScaleStartDetails details, BoxConstraints constraints) {
    camera.onStart();
  }

  /// Updates the camera information with the update details
  void onUpdate(CameraController camera, ScaleUpdateDetails details) {
    camera.onUpdate(details.scale, details.focalPointDelta);
  }

  /// Do nothing
  void onEnd(ScaleEndDetails details) { /* do nothing */ }
}