import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/widgets/canvas/route_painter.dart';

import '../../../domain/space/position.dart';
import '../../../providers/route_manager.dart';

class RouteView extends StatelessWidget {
  final List<Position> hooks;
  final Widget child;
  const RouteView({super.key, required this.hooks, required this.child});

  // constants
  static const Color startColor = Colors.yellowAccent;
  static const Color midColor = Colors.orangeAccent;
  static const Color endColor = Colors.redAccent;

  @override
  Widget build(BuildContext context) =>
      Consumer<RouteManager>(
        builder: (_, pathManager, __) =>
            CustomPaint(
                painter: RoutePainter(
                  hooks: hooks,
                  start: startColor,
                  mid: midColor,
                  end: endColor,
                  points: pathManager.pathPoints
                  ),
                child: Container(child: child)
            )
      );
}