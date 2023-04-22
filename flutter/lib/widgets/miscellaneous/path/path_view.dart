import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/minimap_provider.dart';
import 'package:ship_conquest/providers/route_manager.dart';

import '../../../domain/space/cubic_bezier.dart';
import '../../canvas/draw_star_path.dart';

class PathView extends StatelessWidget {
  final Widget? child;
  const PathView({super.key, this.child});

  @override
  Widget build(BuildContext context) =>
      Consumer<MinimapProvider>(
          builder: (_, minimap, __) =>
              Consumer<RouteManager>(
                  builder: (_, routeManager, __) {
                    return renderNothing();
                    final beziers = routeManager.routePoints;

                    if (beziers == null) return renderNothing();

                    // else calculate path
                    //return bezierPath(beziers);
                  }
              )
      );

  Widget renderNothing() => Container(child: child);

  Widget bezierPath(List<CubicBezier> beziers) =>
      CustomPaint(
          painter: DrawStarPath(
              beziers: beziers
          ),
          child: Container(child: child)
      );

}