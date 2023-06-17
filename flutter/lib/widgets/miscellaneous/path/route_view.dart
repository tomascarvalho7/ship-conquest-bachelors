import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/widgets/canvas/route_painter.dart';

import '../../../domain/space/position.dart';
import '../../../providers/camera_controller.dart';
import '../../../providers/game/minimap_controllers/route_controller.dart';

/// Widget used to paint the ship's route chosen by the player
///
/// - [hooks] the anchor points of the route
/// - [child] a child to be rendered with it
class RouteView extends StatelessWidget {
  final Sequence<Position> hooks;
  final Widget child;
  // constructor
  const RouteView({super.key, required this.hooks, required this.child});

  // constants
  // color used in the gradient
  static const Color startColor = Colors.yellowAccent;
  static const Color midColor = Colors.orangeAccent;
  static const Color endColor = Colors.redAccent;

  @override
  Widget build(BuildContext context) =>
      Consumer<CameraController>(
          builder: (_, camera, __) =>
              Consumer<RouteController>(
                builder: (_, routeController, __) =>
                    CustomPaint(
                        painter: RoutePainter(
                            hooks: hooks,
                            scale: camera.scaleFactor,
                            start: startColor,
                            mid: midColor,
                            end: endColor,
                            points: routeController.pathPoints
                        ),
                        child: Container(child: child)
                    )
              )
      );
}