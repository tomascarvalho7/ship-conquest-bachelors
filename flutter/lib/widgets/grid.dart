import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/tile_manager.dart';
import 'package:ship_conquest/services/ship_services.dart';
import 'package:ship_conquest/widgets/tile.dart';
import 'package:ship_conquest/widgets/water_tile.dart';
import 'package:vector_math/vector_math_64.dart';

import '../domain/coordinate.dart';
import '../domain/isometric_tiles_flow_delegate.dart';
import '../main.dart';
import '../providers/chunk_manager.dart';
import '../providers/camera.dart';

class Grid extends StatefulWidget {
  final Color background;
  final TileManager tileManager;
  const Grid({super.key, required this.background, required this.tileManager});

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> with TickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
      duration: const Duration(seconds: 7),
      vsync: this
  )
    ..repeat();
  late final animation = Tween(begin: 0, end: 2 * pi).animate(controller);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // get context with listen off, so it's not notified
    ChunkManager chunkM = Provider.of<ChunkManager>(context, listen: false);
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
        child: Consumer<ChunkManager>(
            builder: (_, chunkManager, __) =>
                Chunk(animation: animation, tiles: chunkManager.tiles, tileManager: widget.tileManager)
        )
    );
  }
}

class Chunk extends StatelessWidget {
  final Animation<num> animation;
  final List<Coordinate> tiles;
  final TileManager tileManager;
  const Chunk({super.key, required this.animation, required this.tiles, required this.tileManager});

  @override
  Widget build(BuildContext context) {
    return Flow(
        delegate: IsometricTilesFlowDelegate(
            animation: animation,
            tiles: tiles,
            tileSize: tileSize
        ),
        clipBehavior: Clip.none,
        children: List.generate(
            tiles.length,
                (index) => Tile(
                svg: tileManager.getSvg(
                    tiles[index].z
                )
            )
        )
    );
  }
}

