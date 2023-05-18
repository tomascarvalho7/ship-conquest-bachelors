import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/widgets/screens/initial_loading/loading_screen.dart';

import '../../../providers/game/game_controller.dart';

class GameLoadingScreen extends StatelessWidget {
  final String dst;
  const GameLoadingScreen({super.key, required this.dst});

  @override
  Widget build(BuildContext context) {
    final gameController = context.read<GameController>();
    gameController.load().then((_) => context.go("/game-home"));

    return Stack(children: [
      LoadingScreen(),
      Align(
        alignment: const Alignment(0.0, 0.3),
        child: Text("Loading your game...",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.secondary),),
      )
    ]);
  }
}