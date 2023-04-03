
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/color/color_gradient.dart';
import 'package:ship_conquest/domain/game_event.dart';
import 'package:ship_conquest/providers/ship_manager.dart';
import 'package:ship_conquest/widgets/miscellaneous/ship/fleet.dart';
import '../../../main.dart';
import '../../../providers/tile_manager.dart';
import '../../miscellaneous/camera_control.dart';
import 'entities/TilesView.dart';
import '../../miscellaneous/ship/ship_widget.dart';

class GameView extends StatelessWidget {
  final Animation<double> animation;
  final Color background;
  final ColorGradient colorGradient;
  final GameEvent gameEvent;
  // constructor
  const GameView({
    super.key,
    required this.animation,
    required this.background,
    required this.colorGradient,
    required this.gameEvent
  });

  @override
  Widget build(BuildContext context) =>
      CameraControl(
          background: background,
          child: Consumer<TileManager>(
            builder: (_, tileManager, child) =>
                Stack(
                  children: [
                    TilesView(
                      animation: animation,
                      tiles: tileManager.tiles,
                      colorGradient: colorGradient,
                    ),
                    Fleet(
                        widget: (ship) => ShipWidget(
                          position: ship.getPosition(),
                          tileSize: tileSize,
                          animation: animation,
                        )
                    )
                  ],
                ),
          )
      );
}