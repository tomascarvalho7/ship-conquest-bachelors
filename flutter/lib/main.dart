import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/colorGradient.dart';
import 'package:ship_conquest/domain/colorMark.dart';
import 'package:ship_conquest/domain/position.dart';
import 'package:ship_conquest/providers/camera.dart';
import 'package:ship_conquest/providers/chunk_manager.dart';
import 'package:ship_conquest/providers/image_gradient.dart';
import 'package:ship_conquest/providers/tile_manager.dart';
import 'package:ship_conquest/services/fake_ship_services.dart';
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
    int chunkSize = 7;
    ColorGradient colorGradient = ColorGradient(colors: [
      ColorMark(factor: Factor(0.0), color: Colors.blueGrey),
      ColorMark(factor: Factor(1.0), color: Colors.blueAccent)
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
          Provider<ShipServices>(create: (_) => FakeShipServices()),
          Provider(create: (_) => TileManager(colorGradient: colorGradient, step: Factor(0.01)))
        ],
          child: const Grid(background: Colors.blueAccent),
      ),
    );
  }
}

const tileSize = 64.0;