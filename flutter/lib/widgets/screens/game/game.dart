import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/color/color_gradient.dart';
import 'package:ship_conquest/providers/global_state.dart';
import 'package:ship_conquest/providers/game/global_controllers/statistics_controller.dart';
import 'package:ship_conquest/providers/game/event_handlers/game_event.dart';
import 'package:ship_conquest/providers/game/global_controllers/minimap_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/ship_controller.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';
import 'package:ship_conquest/utils/constants.dart';
import 'package:ship_conquest/widgets/screens/game/game_interface.dart';
import 'package:ship_conquest/widgets/screens/game/game_view.dart';
import '../../../providers/game/global_controllers/scene_controller.dart';
import '../../../providers/camera_controller.dart';

/// Builds the game interface and holds the wave animation, which needs to be synchronized through all the elements.
class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this
  )
    ..repeat();
  late final animation = Tween<double>(begin: 0, end: 2 * pi).animate(controller);

  @override
  void initState() {
    GameEvent.load(context); // setup game controllers
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      GameInterface(
          gameView: GameView(
            animation: animation,
            colorGradient: colorGradient,
          )
      );
}

