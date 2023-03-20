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
import 'package:ship_conquest/widgets/authentication/authentication_screen.dart';
import 'package:ship_conquest/widgets/screens/game.dart';
import 'package:ship_conquest/widgets/canvas/painter_preview.dart';
import 'package:ship_conquest/widgets/screens/game_screen.dart';

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
          child: const AuthenticationScreen()
      ),
    );
  }
}

const tileSize = 16.0;