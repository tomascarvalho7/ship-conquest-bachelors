import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/providers/camera_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/ship_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/scene_controller.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../../../domain/island/island.dart';
import '../../../../providers/game/event_handlers/game_event.dart';
import 'game_details_panel.dart';

class GameDetailsSlider extends StatefulWidget {
  // constructor
  const GameDetailsSlider({super.key});

  @override
  State<StatefulWidget> createState() => _GameDetailsSliderState();
}

class _GameDetailsSliderState extends State<GameDetailsSlider> {
  final panelController = PanelController();
  bool isNearbyIslands = false;

  // constants
  static const minSize = 50.0;
  static const maxSize = 500.0;

  @override
  Widget build(BuildContext context) =>
      Consumer<SceneController>(
        builder: (_, tileManager, __) {
          final islands = tileManager.islands;
          manageNearbyIslands(islands);

          return Consumer2<ShipController, CameraController>(
              builder: (_, shipManager, camera, __) =>
                  SlidingUpPanel(
                    controller: panelController,
                    minHeight: minSize,
                    maxHeight: maxSize,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18)
                    ),
                    panelBuilder: (controller) =>
                        GameDetailsPanel(
                            controller: controller,
                            islands: islands,
                            camera: camera,
                            ships: shipManager.ships.toSequence()
                        ),
                  )
            );
        }
      );

  void manageNearbyIslands(Sequence<Island> islands) {
    // if new islands are found, animate slider
    if (!isNearbyIslands && islands.length > 0) {
      panelController.animatePanelToPosition(
          .25,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn
      );
    }

    if (isNearbyIslands && islands.length == 0) {
      panelController.animatePanelToPosition(
          .0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn
      );
    }
    // update nearby islands
    isNearbyIslands = islands.length > 0;
  }
}
