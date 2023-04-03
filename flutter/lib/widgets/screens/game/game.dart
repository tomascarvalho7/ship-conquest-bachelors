import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/color/color_gradient.dart';
import 'package:ship_conquest/domain/game_event.dart';
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // get context with listen off, so it's not notified
    ShipServices services = Provider.of<ShipServices>(context, listen: false);
    // game event class, manages game events
    GameEvent gameEvent = GameEvent(
        camera: Provider.of<Camera>(context, listen: false),
        tileManager: Provider.of<TileManager>(context, listen: false),
        shipManager: Provider.of<ShipManager>(context, listen: false),
        minimapProvider: Provider.of<MinimapProvider>(context, listen: false),
        colorGradient: widget.colorGradient,
    );
    gameEvent.load(services);

    return GameInterface(
        gameView: GameView(
          animation: animation,
          background: widget.background,
          colorGradient: widget.colorGradient,
          gameEvent: gameEvent,
        )
    );
  }
}

