import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/position.dart';
import 'package:ship_conquest/providers/camera.dart';
import 'package:ship_conquest/providers/chunk_manager.dart';
import 'package:ship_conquest/services/fake_ship_services.dart';
import 'package:ship_conquest/services/real_ship_services.dart';
import 'package:ship_conquest/services/ship_services.dart';
import 'package:ship_conquest/widgets/grid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    int chunkSize = 7;
    final ShipServices services = FakeShipServices();

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
          Provider(create: (_) => services)
        ],
          child: const Grid(background: Colors.blueAccent),
      ),
    );
  }
}

const tileSize = 64.0;