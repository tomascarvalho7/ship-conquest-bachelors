import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/color_gradient.dart';
import 'package:ship_conquest/domain/color_ramp.dart';
import 'package:ship_conquest/domain/color_mark.dart';
import 'package:ship_conquest/domain/minimap.dart';
import 'package:ship_conquest/domain/position.dart';
import 'package:ship_conquest/providers/minimap_provider.dart';
import 'package:ship_conquest/providers/user_storage.dart';
import 'package:ship_conquest/providers/camera.dart';
import 'package:ship_conquest/providers/tile_manager.dart';
import 'package:ship_conquest/router.dart';
import 'package:ship_conquest/services/ship_services/fake_ship_services.dart';
import 'package:ship_conquest/services/ship_services/real_ship_services.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';
import 'package:ship_conquest/widgets/screens/signin/authentication_screen.dart';
import 'package:ship_conquest/widgets/screens/game/game.dart';
import 'package:ship_conquest/widgets/canvas/painter_preview.dart';
import 'package:ship_conquest/widgets/screens/game/game_screen.dart';

import 'domain/factor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final chunkSize = 10;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) =>
      MultiProvider(
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
            ChangeNotifierProvider(create: (_) => MinimapProvider()),
            Provider<ShipServices>(create: (_) => RealShipServices()),
            Provider<UserStorage>(create: (_) => UserStorage())
          ],
          child: MaterialApp.router(
              title: 'Ship Conquest',
              theme: ThemeData(primarySwatch: Colors.blue),
              routerConfig: createRouter()
          )
      );
}

const tileSize = 32.0;