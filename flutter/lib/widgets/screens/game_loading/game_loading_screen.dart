import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/game_data.dart';
import 'package:ship_conquest/domain/ship/direction.dart';
import 'package:ship_conquest/domain/ship/dynamic_ship.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/domain/ship/ship_path.dart';
import 'package:ship_conquest/domain/ship/static_ship.dart';
import 'package:ship_conquest/domain/space/position.dart';
import 'package:ship_conquest/domain/space/sequence.dart';
import 'package:ship_conquest/providers/global_state.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';

import '../game/game_screen.dart';

class GameLoadingScreen extends StatelessWidget {
  final String dst;
  const GameLoadingScreen({super.key, required this.dst});

  @override
  Widget build(BuildContext context) {
    final globalState = context.read<GlobalState>();
    final services = context.watch<ShipServices>();

    return FutureBuilder<void>(
      future: fetchGameData(services, globalState),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done) {
          return GameScreen(
            data: globalState.gameData!,
            stats: globalState.playerStats!,
          );
        } else {
          return const Text('Failed to fetch game data.');
        }
      },
    );
  }

  Future<void> fetchGameData(ShipServices services, GlobalState globalState) async {
    final minimap = await services.getMinimap(globalState.colorGradient);
    final result = await services.getMainShipLocation();
    final statistics = await services.getPlayerStatistics();

    late Ship ship;
    if(result is Position) {
      ship = StaticShip(position: result, orientation: Direction.up);
    } else if (result is ShipPath) {
      ship = DynamicShip(path: result);
    }

    globalState.updateGameData(
        GameData(
            minimap: minimap,
            ships: Sequence(data: [ship])
        )
    );
    globalState.updatePlayerStats(statistics);
  }
}