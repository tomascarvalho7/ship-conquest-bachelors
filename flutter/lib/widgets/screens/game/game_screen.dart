import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/game_data.dart';
import 'package:ship_conquest/domain/stats/player_stats.dart';
import 'package:ship_conquest/providers/game/global_controllers/statistics_controller.dart';

import '../../../domain/color/color_gradient.dart';
import '../../../domain/color/color_mark.dart';
import '../../../domain/color/color_ramp.dart';
import '../../../domain/utils/factor.dart';
import '../../../providers/camera_controller.dart';
import '../../../providers/global_state.dart';
import '../../../providers/game/global_controllers/minimap_controller.dart';
import '../../../providers/game/global_controllers/ship_controller.dart';
import '../../../providers/game/global_controllers/scene_controller.dart';
import '../../../utils/constants.dart';
import 'game.dart';

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
