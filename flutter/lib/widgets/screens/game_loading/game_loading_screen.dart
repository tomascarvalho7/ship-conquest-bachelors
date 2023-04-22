import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/game_data.dart';
import 'package:ship_conquest/domain/ship/direction.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/domain/ship/static_ship.dart';
import 'package:ship_conquest/providers/global_state.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';

import '../../../providers/user_storage.dart';

class GameLoadingScreen extends StatelessWidget {
  final String dst;
  const GameLoadingScreen({super.key, required this.dst});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShipServices>(
        builder: (context, services, _) {
          fetchGameData(services, context.read<GlobalState>()).then(
                  (_) => context.go("/$dst")
          );

          return const CircularProgressIndicator();
        }
    );
  }

  Future<void> fetchGameData(ShipServices services, GlobalState globalState) async {
    final minimap = await services.getMinimap(globalState.colorGradient);
    final position = await services.getMainShipPosition();
    globalState.updateGameData(
        GameData(
            minimap: minimap,
            ships: [StaticShip(position: position!, orientation: Direction.up)]
        )
    );
  }
}