import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/game_data.dart';

import '../../../domain/color/color_gradient.dart';
import '../../../domain/color/color_mark.dart';
import '../../../domain/color/color_ramp.dart';
import '../../../domain/utils/factor.dart';
import '../../../providers/camera.dart';
import '../../../providers/global_state.dart';
import '../../../providers/minimap_provider.dart';
import '../../../providers/ship_manager.dart';
import '../../../providers/tile_manager.dart';
import '../../../utils/constants.dart';
import 'game.dart';

class GameScreen extends StatelessWidget {
  final GameData data;
  const GameScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Camera()),
          ChangeNotifierProvider(create: (_) => TileManager(chunkSize: chunkSize, tileSize: tileSize)),
          ChangeNotifierProvider(create: (_) => MinimapProvider(minimap: data.minimap)),
          ChangeNotifierProvider(create: (_) => ShipManager(ships: data.ships))
        ],
        child: Game(
            background: Colors.blueGrey,
            colorGradient: context.read<GlobalState>().colorGradient)
    );
  }
}
