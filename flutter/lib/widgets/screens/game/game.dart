import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/color/color_gradient.dart';
import 'package:ship_conquest/providers/global_state.dart';
import 'package:ship_conquest/providers/statistics_state.dart';
import 'package:ship_conquest/widgets/screens/game/events/game_event.dart';
import 'package:ship_conquest/providers/minimap_provider.dart';
import 'package:ship_conquest/providers/ship_manager.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';
import 'package:ship_conquest/widgets/screens/game/game_interface.dart';
import 'package:ship_conquest/widgets/screens/game/game_view.dart';
import '../../../providers/tile_manager.dart';
import '../../../providers/camera.dart';

class Game extends StatefulWidget {
  final Color background;
  final ColorGradient colorGradient;
  const Game({super.key, required this.background, required this.colorGradient});

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
  late final GameEvent eventHandler;
  late final timer = Timer.periodic(const Duration(seconds: 2), (_) => eventHandler.lookAround());

  @override
  void initState() {
    super.initState();
    // game event class, manages game events
    eventHandler = GameEvent(
      state: context.read<GlobalState>(),
      camera: context.read<Camera>(),
      tileManager: context.read<TileManager>(),
      shipManager: context.read<ShipManager>(),
      minimapProvider: context.read<MinimapProvider>(),
      statisticsState: context.read<StatisticsState>(),
      services: context.read<ShipServices>(),
      colorGradient: widget.colorGradient,
    );
    eventHandler.load(); // load
    final t = timer;
  }

  @override
  void dispose() {
    controller.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GameInterface(
        eventHandler: eventHandler,
        gameView: GameView(
          animation: animation,
          background: widget.background,
          colorGradient: widget.colorGradient,
          gameEvent: eventHandler,
        )
    );
  }



}

