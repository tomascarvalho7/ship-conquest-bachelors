import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/path/path_segment.dart';
import 'package:ship_conquest/domain/space/offset.dart';
import 'package:ship_conquest/widgets/miscellaneous/camera_control.dart';
import 'package:ship_conquest/widgets/screens/minimap/events/minimap_event.dart';

import '../../../../domain/space/position.dart';
import '../../../../providers/camera.dart';
import '../../../../providers/route_manager.dart';

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
  }) {
    // everytime this widget is inserted in the widget tree, setup eventHandler
    eventHandler.setup();
  }

  static const radius = 50;

  // a -> b
  double _distance(Position a, Position b) => sqrt(pow(b.x - a.x, 2) + pow(b.y - a.y, 2));

  @override
  void onStart(Camera camera, ScaleStartDetails details, BoxConstraints constraints) {
    final Position screenPosition = details.localFocalPoint.toPosition() - camera.coordinates * camera.scaleFactor;
    final Position constraintOffset = Position(
        x: constraints.maxWidth / 2,
        y: constraints.maxHeight / 2
    );

    final Position position = (screenPosition - constraintOffset) * (1 / camera.scaleFactor);

    if (selectMainNodes(position, camera.scaleFactor)) return;

    if (selectSecondaryNodes(position, camera.scaleFactor)) return;

    super.onStart(camera, details, constraints);
  }

  @override
  void onUpdate(Camera camera, ScaleUpdateDetails details) {
    if (routeManager.pathSegment == null) {
      super.onUpdate(camera, details);
    } else {
      final Position position = details.focalPointDelta.toPosition() * (1 / camera.scaleFactor);

      eventHandler.moveNode(position);
    }
  }

  @override
  void onEnd(ScaleEndDetails details) {
    eventHandler.deselectAndBuildPath();
    super.onEnd(details);
  }

  bool selectMainNodes(Position position, double scale) {
    final int length = nodes.length;
    for(var i = 0; i < length; i++) {
      final Position hook = nodes[i];
      if (_distance(hook, position) < radius / scale) {
        routeManager.selectMainNode(i);
        return true; // selected a main node !
      }
    }

    return false; // did not select any main nodes :(
  }

  bool selectSecondaryNodes(Position position, double scale) {
    final pathPoints = routeManager.pathPoints;
    if (pathPoints == null) return false; // there are no secondary points

    if (_distance(pathPoints.mid, position) < radius / scale) {
      routeManager.selectSecondaryNode(PathSegment.mid);
      return true; // selected the mid node
    } else if (_distance(pathPoints.end, position) < radius / scale) {
      routeManager.selectSecondaryNode(PathSegment.end);
      return true; // selected the end node
    }

    return false; // did not select any secondary nodes :(
  }
}