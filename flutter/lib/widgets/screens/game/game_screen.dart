import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/camera_controller.dart';
import 'package:ship_conquest/widgets/screens/game/game.dart';

/// Instantiates the game provider to be used and builds the game screen.
class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CameraController())
        ],
        child: const Game()
    );
  }
}
