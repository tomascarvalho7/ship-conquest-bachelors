
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../providers/camera_controller.dart';
import '../../../providers/global_state.dart';
import '../../../providers/game/global_controllers/minimap_controller.dart';
import '../../../providers/game/minimap_controllers/route_controller.dart';
import '../../../providers/game/global_controllers/ship_controller.dart';
import '../../../providers/game/global_controllers/scene_controller.dart';
import '../../../services/ship_services/ship_services.dart';
import '../../../utils/constants.dart';
import 'utils/camera_path_controller.dart';
import '../../miscellaneous/path/path_management_interface.dart';
import '../../miscellaneous/path/path_view.dart';
import '../../miscellaneous/path/route_view.dart';
import '../../../providers/game/event_handlers/minimap_event.dart';
import 'minimap_view.dart';

class MinimapVisuals extends StatelessWidget {
  const MinimapVisuals({super.key});

  @override
  Widget build(BuildContext context) {
    MinimapEvent.load(context); // setup minimap controllers

   return Stack(
     children: [
       minimapInterface(context),
       pathManagementInterfaceHolder(),
       closeButton(() {
         context.go('/game-home'); // return to game screen
       })
     ],
   );
  }

  Widget minimapInterface(BuildContext context) {
    final routeController = context.read<RouteController>();

    return Consumer<MinimapController>(
        builder: (_, minimapController, __) {
          final scale = minimapSize / minimapController.minimap.length;
          return Consumer<ShipController>(
              builder: (_, shipController, __) {
                final ships = shipController.getShipPositions(scale);
                routeController.setupHooks(ships);
                return CameraPathController(
                    context: context,
                    routeController: routeController,
                    background: const Color.fromRGBO(51, 56, 61, 1),
                    nodes: ships,
                    child: MinimapView(
                        gradient: colorGradient,
                        minimap: minimapController.minimap,
                        child: RouteView(
                            hooks: ships,
                            child: const PathView()
                        )
                    )
                );
              }
          );
        }
    );
  }

  Widget pathManagementInterfaceHolder() =>
      const Positioned(
          bottom: 20,
          child: PathManagementInterface()
      );

  Widget closeButton(void Function() onPressed) =>
      Positioned(
          right: 0,
          top: 40,
          child: FloatingActionButton(
              onPressed: onPressed,
              backgroundColor: Colors.redAccent,
              child: const SizedBox(width: 50, height: 50,)
          )
      );
}