import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/color_gradient.dart';
import 'package:ship_conquest/main.dart';
import 'package:ship_conquest/services/ship_services.dart';
import 'package:ship_conquest/widgets/isometric_painter.dart';
import 'package:vector_math/vector_math_64.dart';

import '../domain/coordinate.dart';
import '../domain/isometric_tile.dart';
import '../providers/tile_manager.dart';
import '../providers/camera.dart';

class Grid extends StatefulWidget {
  final Color background;
  final ColorGradient colorGradient;
  const Grid({super.key, required this.background, required this.colorGradient});

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> with TickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this
  )
    ..repeat();
  late final animation = Tween<double>(begin: 0, end: 2 * pi).animate(controller);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // get context with listen off, so it's not notified
    TileManager chunkM = Provider.of<TileManager>(context, listen: false);
    ShipServices services = Provider.of<ShipServices>(context, listen: false);
    Camera cameraM = Provider.of<Camera>(context, listen: false);
    chunkM.manageChunks(cameraM.centerCoordinates, services);

    return Consumer<Camera>(
        builder: (_, camera, child) =>
            GestureDetector(
                onScaleStart: (details) => camera.onStart(),
                onScaleUpdate: (details) {
                  camera.onUpdate(details.scale, details.focalPointDelta);
                  chunkM.manageChunks(camera.centerCoordinates / camera.scaleFactor, services);
                },
                child: Container(
                    color: widget.background,
                    width: double.infinity,
                    height: double.infinity,
                    child: Transform(
                      transform: Matrix4.compose(
                          Vector3(camera.coordinates.dx, camera.coordinates.dy, 0.0),
                          Quaternion.identity(),
                          Vector3.all(camera.scaleFactor)
                      ),
                      child: child,
                    )
                )
            ),
        child: Consumer<TileManager>(
            builder: (_, tileManager, __) =>
                TilesView(animation: animation, tiles: tileManager.tiles, colorGradient: widget.colorGradient)
        )
    );
  }
}

class TilesView extends StatelessWidget {
  final Animation<double> animation;
  final List<Coordinate> tiles;
  final ColorGradient colorGradient;
  final double tileSizeWidthHalf = tileSize / 2;
  final double tileSizeHeightHalf = tileSize / 4;
  const TilesView({super.key, required this.animation, required this.tiles, required this.colorGradient});

  @override
  Widget build(BuildContext context) {
    List<IsometricTile> isoTiles = tiles.map((coord) {
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
    }).toList(growable: false);

    return CustomPaint(
      painter: IsometricPainter(
          tileSize: tileSize,
          animation: animation,
          tiles: isoTiles
      ),
      child: Container()
    );
  }
}

