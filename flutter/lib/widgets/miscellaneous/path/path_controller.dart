import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/space/offset.dart';
import 'package:ship_conquest/domain/space/pathPoints.dart';
import 'package:ship_conquest/providers/path_manager.dart';

import '../../../domain/space/position.dart';
import 'anchor.dart';
import 'draw_path.dart';

class PathController extends StatelessWidget {
  final Position start;
  final Widget widget;
  // constructor
  const PathController({super.key, required this.start, required this.widget});

  // constants
  static const Color startColor = Colors.yellowAccent;
  static const Color midColor = Colors.orangeAccent;
  static const Color endColor = Colors.redAccent;

  @override
  Widget build(BuildContext context) =>
      Consumer<PathManager>( // Consumer to update Path according to PathManager
          builder: (_, pathManager, __) {
            final pathPoints = pathManager.pathPoints;

            return Stack(
                children: pathPoints != null
                    ? pathComponents(pathPoints, pathManager)
                    : [drawWidgetWithAnchor(pathManager)]
            );
          }
      );

  Widget drawWidgetWithAnchor(pathManager) => GestureDetector(
      onPanUpdate: (details) =>
          pathManager.draw(start, details.delta.toPosition()),
      child: widget
  );


  List<Widget> pathComponents(PathPoints pathPoints, PathManager pathManager) =>
      [
        Center(
          child: DrawPath(
              pathPoints: pathManager.pathPoints,
              start: startColor,
              mid: midColor,
              end: endColor
          )
        ),
        drawWidgetWithAnchor(pathManager),
        Anchor(
          position: pathPoints.mid,
          color: midColor,
          onPan: (details) => pathManager.updateMid(details.delta.toPosition()),
        ),
        Anchor(
          position: pathPoints.end,
          color: endColor,
          onPan: (details) => pathManager.updateEnd(details.delta.toPosition()),
        )
      ];
}