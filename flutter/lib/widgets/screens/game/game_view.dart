import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/color/color_gradient.dart';
import 'package:ship_conquest/providers/camera_controller.dart';
import 'package:ship_conquest/widgets/miscellaneous/ship/dynamic_ship_widget.dart';
import 'package:ship_conquest/widgets/screens/game/utils/islands_view.dart';
import 'package:ship_conquest/widgets/screens/game/utils/tiles_view.dart';
import 'package:ship_conquest/widgets/miscellaneous/ship/fleet.dart';
import '../../../domain/ship/ship.dart';
import '../../../providers/game/global_controllers/scene_controller.dart';
import '../../../utils/constants.dart';
import '../../miscellaneous/camera_control.dart';
import '../../miscellaneous/ship/ship_widget.dart';

/// Builds the actual game view with all the tiles islands, by also
/// instantiating [CameraControl] to manage the camera.
class GameView extends StatelessWidget {
  final Animation<double> animation;
  final ColorGradient colorGradient;
  // constructor
  const GameView({
    super.key,
    required this.animation,
    required this.colorGradient
  });

  @override
  Widget build(BuildContext context) =>
      CameraControl(
          background: Theme.of(context).colorScheme.background,
          child: Consumer<SceneController>(
            builder: (_, tileManager, child) =>
                Stack(
                  children: [
                    TilesView(
                      animation: animation,
                      tiles: tileManager.tiles,
                      colorGradient: colorGradient,
                    ),
                    IslandsView(
                        islands: tileManager.islands
                    ),
                    if (child != null) child
                  ],
                ),
            child: Fleet(animation: animation),
          )
      );
}