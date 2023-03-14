import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/colorGradient.dart';
import 'package:ship_conquest/domain/colorMark.dart';
import 'package:ship_conquest/domain/position.dart';
import 'package:ship_conquest/domain/tile.dart';
import 'package:ship_conquest/providers/camera.dart';
import 'package:ship_conquest/providers/chunk_manager.dart';
import 'package:ship_conquest/domain/tile_manager.dart';
import 'package:ship_conquest/services/real_ship_services.dart';
import 'package:ship_conquest/services/ship_services.dart';
import 'package:ship_conquest/widgets/grid.dart';

import 'domain/factor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    int chunkSize = 40;
    ColorGradient colorGradient = ColorGradient(colors: [
      ColorMark(factor: Factor(0.0), color: const Color.fromRGBO(196, 195, 175, 255)),
      ColorMark(factor: Factor(0.15), color: const Color.fromRGBO(179, 181, 122, 255)),
      ColorMark(factor: Factor(0.2), color: const Color.fromRGBO(116, 153, 72, 255)),
      ColorMark(factor: Factor(0.3), color: const Color.fromRGBO(77, 130, 40, 255)),
      ColorMark(factor: Factor(0.7), color: const Color.fromRGBO(177, 211, 114, 255)),
      ColorMark(factor: Factor(0.71), color: const Color.fromRGBO(170, 145, 107, 255)),
      ColorMark(factor: Factor(0.85), color: const Color.fromRGBO(174, 154, 127, 255)),
      ColorMark(factor: Factor(1.0), color: const Color.fromRGBO(255, 255, 255, 255)),
    ]);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => Camera(
                  origin: Position(
                      x: - MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width / 2,
                      y: - MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height / 4
                  )
              )
          ),
          ChangeNotifierProvider(
              create: (_) => ChunkManager(chunkSize: chunkSize, tileSize: tileSize)
          ),
          Provider<ShipServices>(create: (_) => RealShipServices())
        ],
          child: FutureBuilder(
              future: rootBundle.loadString('assets/svg/cube.svg').then(
                      (value) => value
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  TileManager tileManager = TileManager(svg: snapshot.data!, colorGradient: colorGradient, step: Factor(0.01));
                  return Grid(background: Colors.blueAccent, tileManager: tileManager);
                } else {
                  return const Text("Loading...");
                }
              }
        ),
      ),
    );
  }
}

const tileSize = 64.0;