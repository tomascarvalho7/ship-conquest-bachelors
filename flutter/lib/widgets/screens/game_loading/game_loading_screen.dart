import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../providers/game/game_controller.dart';

class GameLoadingScreen extends StatelessWidget {
  final String dst;
  const GameLoadingScreen({super.key, required this.dst});

  @override
  Widget build(BuildContext context) {
    final gameController = context.read<GameController>();
    gameController.load().then((_) => context.go("/game-home"));

    return const CircularProgressIndicator();
  }
}