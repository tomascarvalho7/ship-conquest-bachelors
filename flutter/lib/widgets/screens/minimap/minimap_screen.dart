import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/camera.dart';
import 'package:ship_conquest/providers/global_state.dart';
import 'package:ship_conquest/providers/minimap_provider.dart';
import 'package:ship_conquest/providers/route_manager.dart';
import 'package:ship_conquest/providers/ship_manager.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';
import 'package:ship_conquest/utils/constants.dart';
import 'package:ship_conquest/widgets/miscellaneous/path/camera_path_controller.dart';
import 'package:ship_conquest/widgets/miscellaneous/path/path_management_interface.dart';
import 'package:ship_conquest/widgets/miscellaneous/path/path_view.dart';
import 'package:ship_conquest/widgets/screens/minimap/events/minimap_event.dart';
import 'package:ship_conquest/widgets/screens/minimap/minimap_view.dart';
import '../../../domain/game_data.dart';
import '../../../providers/tile_manager.dart';
import '../../miscellaneous/path/route_view.dart';
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