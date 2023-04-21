import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../minimap/minimap_icon.dart';

class GameInterface extends StatelessWidget {
  final Widget gameView;
  const GameInterface({super.key, required this.gameView});

  @override
  Widget build(BuildContext context) =>
      Stack(
        children: [
          gameView,
          MinimapIcon(onClick: () => context.push('/game/minimap'))
        ]
      );
}