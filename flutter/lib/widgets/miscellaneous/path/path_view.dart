import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/path/path_points.dart';
import 'package:ship_conquest/widgets/canvas/path_painter.dart';

import '../../../domain/space/position.dart';
import '../../../providers/path_manager.dart';

class PathView extends StatelessWidget {
  final List<Position> hooks;
  const PathView({super.key, required this.hooks});

  // constants
  static const Color startColor = Colors.yellowAccent;
  static const Color midColor = Colors.orangeAccent;
  static const Color endColor = Colors.redAccent;

  @override
  Widget build(BuildContext context) =>
      Consumer<PathManager>(
        builder: (_, pathManager, __) =>
            CustomPaint(
                painter: PathPainter(
                  hooks: hooks,
                  start: startColor,
                  mid: midColor,
                  end: endColor,
                  points: pathManager.pathPoints
                  ),
                child: Container()
            )
      );
}