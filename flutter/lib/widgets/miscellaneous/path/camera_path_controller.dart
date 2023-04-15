import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/path/path_segment.dart';
import 'package:ship_conquest/domain/space/offset.dart';
import 'package:ship_conquest/widgets/miscellaneous/camera_control.dart';
import 'package:ship_conquest/widgets/screens/minimap/events/minimap_event.dart';

import '../../../domain/space/position.dart';
import '../../../providers/camera.dart';
import '../../../providers/route_manager.dart';

class CameraPathController extends CameraControl {
  final List<Position> nodes;
  final MinimapEvent eventHandler;
  late final RouteManager routeManager = eventHandler.route;
  // constructor
  CameraPathController({
    super.key,
    required super.background,
    required super.child,
    required this.eventHandler,
    required this.nodes,
  });

  static const radius = 100;

  // a -> b
  double _distance(Position a, Position b) => sqrt(pow(b.x - a.x, 2) + pow(b.y - a.y, 2));

  Position _scale(Position p, double s) => Position(x: p.x / s, y: p.y / s);

  @override
  void onStart(Camera camera, ScaleStartDetails details, BoxConstraints constraints) {
    final Position screenPosition = details.localFocalPoint.toPosition() - camera.coordinates;
    final Position constraintOffset = Position(
        x: constraints.maxWidth / 2,
        y: constraints.maxHeight / 2
    );

    final Position position = _scale(screenPosition - constraintOffset, camera.scaleFactor);

    if (selectMainNodes(position, camera.scaleFactor)) return;

    if (selectSecondaryNodes(position, camera.scaleFactor)) return;

    super.onStart(camera, details, constraints);
  }

  @override
  void onUpdate(Camera camera, ScaleUpdateDetails details) {
    if (routeManager.pathSegment == null) {
      super.onUpdate(camera, details);
    } else {
      final Position position = _scale(details.focalPointDelta.toPosition(), camera.scaleFactor);

      eventHandler.moveNode(position);
    }
  }

  @override
  void onEnd(ScaleEndDetails details) {
    routeManager.deselect();
    super.onEnd(details);
  }

  bool selectMainNodes(Position position, double scale) {
    final int length = nodes.length;
    for(var i = 0; i < length; i++) {
      final Position hook = nodes[i];
      if (_distance(hook, position) < radius) {
        routeManager.selectMainNode(hook);
        return true; // selected a main node !
      }
    }

    return false; // did not select any main nodes :(
  }

  bool selectSecondaryNodes(Position position, double scale) {
    final pathPoints = routeManager.pathPoints;
    if (pathPoints == null) return false; // there are no secondary points

    if (_distance(pathPoints.mid, position) < radius) {
      routeManager.selectSecondaryNode(PathSegment.mid);
      return true; // selected the mid node
    } else if (_distance(pathPoints.end, position) < radius) {
      routeManager.selectSecondaryNode(PathSegment.end);
      return true; // selected the end node
    }

    return false; // did not select any secondary nodes :(
  }
}