import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart';

import '../../providers/camera.dart';

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
              Consumer<Camera>(
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

  void onTap(Camera camera, TapDownDetails details, BoxConstraints constraints) {
    // do nothing
  }

  void onStart(Camera camera, ScaleStartDetails details, BoxConstraints constraints) {
    camera.onStart();
  }

  void onUpdate(Camera camera, ScaleUpdateDetails details) {
    camera.onUpdate(details.scale, details.focalPointDelta);
  }

  void onEnd(ScaleEndDetails details) { /* do nothing */ }
}