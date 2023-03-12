import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/tile_manager.dart';
import 'package:ship_conquest/services/ship_services.dart';
import 'package:ship_conquest/widgets/tile.dart';
import 'package:vector_math/vector_math_64.dart';

import '../main.dart';
import '../providers/chunk_manager.dart';
import '../providers/camera.dart';
import 'chunk_widget.dart';

class Grid extends StatefulWidget {
  final Color background;
  const Grid({super.key, required this.background});

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> with TickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
      duration: const Duration(seconds: 7),
      vsync: this
  )
    ..repeat();

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
    TileManager tileManager= Provider.of<TileManager>(context, listen: false);

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
                Stack(
                    children: List.generate(
                        chunkManager.visibleChunks.length,
                            (index) => ChunkWidget(
                              chunk: chunkManager.visibleChunks[index],
                              controller: controller,
                              tileSize: tileSize,
                              tileManager: tileManager,
                        )
                    )
                )
        )
    );
  }
}

class TileWrapper extends StatelessWidget {
  final int x;
  final int y;
  final int z;
  final AnimationController controller;
  final Uint8List image;
  TileWrapper ({super.key, required this.x, required this.y, required this.z, required this.controller, required this.image});

  //late final animation = Tween(begin: 0, end: 2 * pi).animate(controller);

  late final double xCoords = (((y * -.5) + (x * 0.5)) * tileSize) - tileSize / 2;
  late final double yCoords = (((y * .25) + (x * .25)) * tileSize) - tileSize / 2;
  //late final double waveOffset = (-x - y) / 3;

  @override
  Widget build(BuildContext context) {
    return Tile(x: xCoords, y: yCoords, z: z, image: image);

    /*AnimatedBuilder(
        animation: animation,
        child: Tile(x: xCoords, y: yCoords),
        builder: (context, child) {
          return Transform.translate(
              offset: Offset(0.0, sin(animation.value + waveOffset) * (tileSize / 2)),
              child: child
          );
        }
    );*/
  }
}
/*
class ShipWrapper extends StatelessWidget {
  final int x;
  final int y;
  final AnimationController controller;
  ShipWrapper ({super.key, required this.x, required this.y, required this.controller});

  late final animation = Tween(begin: 0, end: 2 * pi).animate(controller);

  late final double xCoords = ((y * -.5) + (x * 0.5)) * tileSize;
  late final double yCoords = ((y * .25) + (x * .25)) * tileSize;
  late final double offset = (-6 - 3) / 3;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        child: Ship(x: xCoords, y: yCoords),
        builder: (context, child) {
          return Transform.translate(
              offset: Offset(0.0, sin(animation.value + offset) * (tileSize / 2)),
              child: child
          );
        }
    );
  }*/

