import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/color_gradient.dart';
import 'package:ship_conquest/domain/game_loop.dart';
import 'package:ship_conquest/main.dart';
import 'package:ship_conquest/providers/minimap_provider.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';
import 'package:ship_conquest/widgets/canvas/isometric_painter.dart';
import 'package:ship_conquest/widgets/screens/game/game_interface.dart';
import 'package:ship_conquest/widgets/screens/game/entities/ship_widget.dart';
import 'package:vector_math/vector_math_64.dart';

import '../../../domain/coordinate.dart';
import '../../../domain/isometric_tile.dart';
import '../../../providers/tile_manager.dart';
import '../../../providers/camera.dart';
import 'minimap/minimap_view.dart';

class Game extends StatefulWidget {
  final Color background;
  final ColorGradient colorGradient;
  const Game({super.key, required this.background, required this.colorGradient});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
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
    MinimapProvider minimapProvider = Provider.of<MinimapProvider>(context, listen: false);
    // game event class, manages game events
    GameEvent gameLoop = GameEvent(
        camera: cameraM,
        tileManager: chunkM,
        minimapProvider: minimapProvider,
        colorGradient: widget.colorGradient
    );
    gameLoop.load(services);

    return GameInterface(
        gameView: Consumer<Camera>(
            builder: (_, camera, child) =>
                GestureDetector(
                    onScaleStart: (details) => camera.onStart(),
                    onScaleUpdate: (details) {
                      camera.onUpdate(details.scale, details.focalPointDelta);
                      gameLoop.lookAround(services);
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
              builder: (_, tileManager, child) =>
                  TilesView(
                    animation: animation,
                    tiles: tileManager.tiles,
                    colorGradient: widget.colorGradient,
                    child: child,
                  ),
              child: ShipWidget(
                coord: Coordinate(x: 5, y: 5, z: 0),
                tileSize: tileSize,
                animation: animation,
              ),
            )
        ),
      minimapView: () =>
        Consumer<MinimapProvider>(
          builder: (_, minimapProv, __) =>
              MinimapView(minimap: minimapProv.minimap)
        ),
    );
  }
}

class TilesView extends StatelessWidget {
  final Animation<double> animation;
  final List<Coordinate> tiles;
  final ColorGradient colorGradient;
  final Widget? child;

  const TilesView({super.key, required this.animation, required this.tiles, required this.colorGradient, this.child});

  // optimizations
  final double tileSizeWidthHalf = tileSize / 2;
  final double tileSizeHeightHalf = tileSize / 4;

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
      child: child
    );
  }
}

