import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/space/cubic_bezier.dart';
import 'package:ship_conquest/providers/game/global_controllers/minimap_controller.dart';
import 'package:ship_conquest/providers/game/minimap_controllers/route_controller.dart';

import 'testing/draw_star_path.dart';

/// Widget used to render the actual calculated points by the A* algorithm, when calculated.
/// Can be used for testing purposes so it has enough value to still be in the codebase.
class PathView extends StatelessWidget {
  final Widget? child;
  const PathView({super.key, this.child});

  @override
  Widget build(BuildContext context) =>
      Consumer<MinimapController>(
          builder: (_, minimap, __) =>
              Consumer<RouteController>(
                  builder: (_, routeManager, __) {
                    return renderNothing();
                    /*final beziers = routeManager.routePoints;

                    if (beziers == null) return renderNothing();

                     else calculate path
                    return bezierPath(beziers);*/
                  }
              )
      );

  Widget renderNothing() => Container(child: child);

  Widget bezierPath(List<CubicBezier> beziers) =>
      CustomPaint(
        painter: DrawStarPath(beziers: beziers),
        child: Container(child: child),
      );
  }