import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/camera.dart';
import 'package:ship_conquest/providers/minimap_provider.dart';
import 'package:ship_conquest/providers/route_manager.dart';
import 'package:ship_conquest/providers/ship_manager.dart';
import 'package:ship_conquest/utils/constants.dart';
import '../../../domain/game_data.dart';
import '../../../providers/tile_manager.dart';
import 'minimap_state_widget.dart';

class MinimapScreen extends StatelessWidget {
  final GameData data;
  const MinimapScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) =>
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => Camera()),
            ChangeNotifierProvider(create: (_) => RouteManager()),
            ChangeNotifierProvider(create: (_) => TileManager(chunkSize: chunkSize, tileSize: tileSize)),
            ChangeNotifierProvider(create: (_) => MinimapProvider(minimap: data.minimap)),
            ChangeNotifierProvider(create: (_) => ShipManager(ships: data.ships))
          ],
          child: const MinimapStateWidget(),
      );
}