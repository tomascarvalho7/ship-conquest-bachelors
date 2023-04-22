import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ship_conquest/widgets/screens/game/events/game_event.dart';

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
          MinimapIcon(onClick: () {
            eventHandler.saveGameData();
            context.go('/minimap'); // go to minimap screen
          })
        ]
      );
}