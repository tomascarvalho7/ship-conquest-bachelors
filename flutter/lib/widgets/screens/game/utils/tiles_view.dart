import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/tile/tiles_order.dart';

import '../../../../domain/color/color_gradient.dart';
import '../../../../domain/isometric/isometric_tile.dart';
import '../../../../domain/space/coordinate.dart';
import '../../../../utils/constants.dart';
import '../../../canvas/isometric_painter.dart';

class TilesView extends StatefulWidget {
  final Animation<double> animation;
  final TilesOrder<Coordinate> tiles;
  final ColorGradient colorGradient;
  // constructor
  TilesView({super.key, required this.animation, required this.tiles, required this.colorGradient});

  late final TilesOrder<IsometricTile> isoTiles = TilesOrder(
    tilesStates: tiles.tilesStates,
    tiles: tiles.tiles.map((coord) {
      if (coord.z == 0) {
        return IsometricTile.fromWaterTile(
            coordinate: coord,
            tileSize: tileSize,
            color: colorGradient.get(coord.z)
        );
      } else {
        return IsometricTile.fromTerrainTile(
            coordinate: coord,
            tileSize: tileSize,
            color: colorGradient.get(coord.z)
        );
      }
    })
  );

  @override
  State<StatefulWidget> createState() => _TilesViewState();
}

class _TilesViewState extends State<TilesView> with TickerProviderStateMixin {
  late AnimationController controller = AnimationController(
      duration: const Duration(seconds: 1), vsync: this
  )..forward();
  late Animation<double> animation = Tween<double>(begin: 0, end: 1).animate(controller);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TilesView oldWidget) {
    if(oldWidget.tiles != widget.tiles) {
      // reset animation
      controller.forward(from: 0.0);
      animation = Tween<double>(begin: 0, end: 1).animate(controller);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) =>
      RepaintBoundary(
        child: CustomPaint(
            painter: IsometricPainter(
              tileSize: tileSize,
              waveAnim: widget.animation,
              fadeAnim: animation,
              tilesOrder: widget.isoTiles,
            )
        )
      );
}