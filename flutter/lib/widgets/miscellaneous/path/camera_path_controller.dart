import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/path/path_segment.dart';
import 'package:ship_conquest/domain/space/offset.dart';
import 'package:ship_conquest/widgets/miscellaneous/camera_control.dart';

import '../../../domain/space/position.dart';
import '../../../providers/camera.dart';
import '../../../providers/path_manager.dart';

class CameraPathController extends CameraControl {
  final List<Position> nodes;
  final PathManager pathManager;
  // constructor
  const CameraPathController({
    super.key,
    required super.background,
    required super.child,
    required this.pathManager,
    required this.nodes
  });

  static const radius = 100;

  // a -> b
  double _distance(Position a, Position b) => sqrt(pow(b.x - a.x, 2) + pow(b.y - a.y, 2));

  @override
  void onStart(Camera camera, ScaleStartDetails details) {
    final Position position = details.localFocalPoint.toPosition() - camera.coordinates;

    if (selectMainNodes(position)) return;

    if (selectSecondaryNodes(position)) return;

    super.onStart(camera, details);
  }

  @override
  void onUpdate(Camera camera, ScaleUpdateDetails details) {
    if (pathManager.pathSegment == null) {
      super.onUpdate(camera, details);
    } else {
      final Position position = details.localFocalPoint.toPosition() - camera.coordinates;

      pathManager.moveNode(position);
    }
  }

  @override
  void onEnd(ScaleEndDetails details) {
    pathManager.deselect();
    super.onEnd(details);
  }

  bool selectMainNodes(Position position) {
    final int length = nodes.length;
    for(var i = 0; i < length; i++) {
      final Position hook = nodes[i];
      if (_distance(hook, position) < radius) {
        pathManager.selectMainNode(hook);
        return true; // selected a main node !
      }
    }

    return false; // did not select any main nodes :(
  }

  bool selectSecondaryNodes(Position position) {
    final pathPoints = pathManager.pathPoints;
    if (pathPoints == null) return false; // there are no secondary points

    if (_distance(pathPoints.mid, position) < radius) {
      pathManager.selectSecondaryNode(PathSegment.mid);
      return true; // selected the mid node
    } else if (_distance(pathPoints.end, position) < radius) {
      pathManager.selectSecondaryNode(PathSegment.end);
      return true; // selected the end node
    }

    return false; // did not select any secondary nodes :(
  }
}