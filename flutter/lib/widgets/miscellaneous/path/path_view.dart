import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/path_finding/build_path.dart';
import 'package:ship_conquest/providers/minimap_provider.dart';
import 'package:ship_conquest/providers/route_manager.dart';

import '../../../domain/space/quadratic_bezier.dart';
import '../../canvas/draw_star_path.dart';
/*
class PathView extends StatelessWidget {
  const PathView({super.key});

  @override
  Widget build(BuildContext context) =>
    Consumer<MinimapProvider>(
        builder: (_, minimap, __) =>
          Consumer<RouteManager>(
              builder: (_, routeManager, __) {
                // calculate path
                final points = routeManager.pathPoints;
                // if there are no points => render nothing
                if (points == null) return renderNothing();
                // else calculate path
                return FutureBuilder(
                    future: buildPath(minimap.minimap, points.start, points.mid, points.end, radius),
                    builder: (_, snapshot) =>
                );
              }
          )
    );

  Widget renderNothing() => Container();

  Widget bezierPath(List<QuadraticBezier> beziers) =>
      CustomPaint(
        painter: DrawStarPath(
            beziers: beziers
        ),
        child: Container()
      );

}*/