import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../providers/game/game_controller.dart';
import '../initial_loading/loading_screen.dart';

class LeaveGameScreen extends StatefulWidget {
  const LeaveGameScreen({Key? key}) : super(key: key);

  @override
  _LeaveGameScreenState createState() => _LeaveGameScreenState();
}

class _LeaveGameScreenState extends State<LeaveGameScreen> {
  bool _isNavigated = false;

  @override
  void initState() {
    super.initState();
    final gameController = context.read<GameController>();
    gameController.exit();
    Future.delayed(const Duration(seconds: 1)).then((_) {
      if (!_isNavigated) {
        context.go("/home");
        _isNavigated = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      LoadingScreen(),
      Align(
        alignment: const Alignment(0.0, 0.3),
        child: Text("Saving game info...",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.secondary),),
      )
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    // Set _isNavigated to true when the widget is disposed to prevent navigation
    // from being triggered if the user navigates back to this screen
    _isNavigated = true;
  }
}
