import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/color_gradient.dart';
import 'package:ship_conquest/domain/color_ramp.dart';
import 'package:ship_conquest/domain/color_mark.dart';
import 'package:ship_conquest/domain/position.dart';
import 'package:ship_conquest/providers/camera.dart';
import 'package:ship_conquest/providers/tile_manager.dart';
import 'package:ship_conquest/services/fake_ship_services.dart';
import 'package:ship_conquest/services/real_ship_services.dart';
import 'package:ship_conquest/services/ship_services.dart';
import 'package:ship_conquest/widgets/grid.dart';
import 'package:ship_conquest/widgets/painter_preview.dart';

import 'domain/factor.dart';

void main() {
  runApp(const MyApp());
  //runApp(const PainterPreview());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    int chunkSize = 35;
    ColorRamp colorRamp = ColorRamp(colors: [
      ColorMark(factor: Factor(0.0), color: Colors.blue),
      ColorMark(factor: Factor(0.01), color: const Color.fromRGBO(196, 195, 175, 1.0)),
      ColorMark(factor: Factor(0.15), color: const Color.fromRGBO(210, 202, 151, 1.0)),
      ColorMark(factor: Factor(0.2), color: const Color.fromRGBO(116, 153, 72, 1.0)),
      ColorMark(factor: Factor(0.3), color: const Color.fromRGBO(77, 130, 40, 1.0)),
      ColorMark(factor: Factor(0.7), color: const Color.fromRGBO(177, 211, 114, 1.0)),
      ColorMark(factor: Factor(0.71), color: const Color.fromRGBO(170, 145, 107, 1.0)),
      ColorMark(factor: Factor(0.85), color: const Color.fromRGBO(157, 117, 64, 1.0)),
      ColorMark(factor: Factor(1.0), color: const Color.fromRGBO(255, 255, 255, 1.0)),
    ]);

    return MaterialApp(
      title: 'Ship Conquest',
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
              create: (_) => TileManager(chunkSize: chunkSize, tileSize: tileSize)
          ),
          Provider<ShipServices>(create: (_) => RealShipServices())
        ],
          child: Grid(
              background: Colors.blueAccent,
              colorGradient: ColorGradient(colorRamp: colorRamp, step: Factor(0.01))),
      ),
    );
  }
}

const tileSize = 16.0;