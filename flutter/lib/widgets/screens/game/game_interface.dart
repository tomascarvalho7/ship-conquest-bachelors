import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/stats/player_stats.dart';
import 'package:ship_conquest/providers/tile_manager.dart';
import 'package:ship_conquest/widgets/screens/game/events/game_event.dart';
import 'package:ship_conquest/widgets/screens/game/utils/currency_view.dart';
import 'package:ship_conquest/widgets/screens/game/utils/game_details_scrollable.dart';

import '../minimap/minimap_icon.dart';

class GameInterface extends StatelessWidget {
  final Widget gameView;
  final GameEvent eventHandler;
  const GameInterface({super.key, required this.eventHandler, required this.gameView});

  @override
  Widget build(BuildContext context) =>
      Stack(
        children: [
          gameView,
          topBar(context),
          GameDetailsScrollable(eventHandler: eventHandler)
        ]
      );

  Widget topBar(BuildContext context) =>
      Align(
        alignment: const Alignment(0.0, -0.9),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MinimapIcon(
                  onClick: () {
                    eventHandler.saveGameData();
                    context.go('/minimap'); // go to minimap screen
                  }
              ),
              const SizedBox(width: 150),
              const CurrencyView()
            ]
        )
      );
}