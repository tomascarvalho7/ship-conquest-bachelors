import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/game/event_handlers/minimap_event.dart';
import 'package:ship_conquest/providers/game/global_controllers/minimap_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/ship_controller.dart';
import 'package:ship_conquest/providers/game/minimap_controllers/route_controller.dart';
import 'package:ship_conquest/utils/constants.dart';
import 'package:ship_conquest/widgets/miscellaneous/path/path_management_interface.dart';
import 'package:ship_conquest/widgets/miscellaneous/path/path_view.dart';
import 'package:ship_conquest/widgets/miscellaneous/path/route_view.dart';
import 'package:ship_conquest/widgets/screens/minimap/minimap_view.dart';
import 'package:ship_conquest/widgets/screens/minimap/utils/camera_path_controller.dart';



/// Builds the whole minimap screen by joining the smaller parts together.
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
       }, context)
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
                    background: Theme.of(context).colorScheme.background,
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

  Widget closeButton(void Function() onPressed, BuildContext context) =>
      Positioned(
          right: 0,
          top: 40,
          child: FloatingActionButton(
              onPressed: onPressed,
              backgroundColor: Colors.redAccent,
              child:  Icon(
                Icons.close,
                size: 30,
                color: Theme.of(context).colorScheme.background,
              )
          )
      );
}