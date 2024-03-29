import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/game/game_controller.dart';
import 'package:ship_conquest/widgets/screens/wave_loading_screen/loading_screen.dart';


/// A loading screen which loads the current game's info.
///
/// If the game is correctly loaded then proceed to its view, else go back to home.
class GameLoadingScreen extends StatefulWidget {
  const GameLoadingScreen({super.key});

  @override
  State<StatefulWidget> createState() => GameLoadingScreenState();
}

class GameLoadingScreenState extends State<GameLoadingScreen> {

  @override
  void initState() {
    final gameController = context.read<GameController>();
    gameController.load().then((feedback) {
      if(feedback.isLeft) {
        context.go("/home");
      } else {
        context.go("/game-home");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      Stack(children: [
        LoadingScreen(),
        Align(
          alignment: const Alignment(0.0, 0.3),
          child: Text("Loading your game...",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.secondary),),
        )
    ]);
}