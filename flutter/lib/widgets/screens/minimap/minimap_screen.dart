import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/camera.dart';
import 'package:ship_conquest/providers/minimap_provider.dart';
import 'package:ship_conquest/providers/route_manager.dart';
import 'package:ship_conquest/providers/ship_manager.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';
import 'package:ship_conquest/widgets/miscellaneous/path/camera_path_controller.dart';
import 'package:ship_conquest/widgets/miscellaneous/path/path_management_interface.dart';
import 'package:ship_conquest/widgets/miscellaneous/path/path_view.dart';
import 'package:ship_conquest/widgets/screens/minimap/events/minimap_event.dart';
import 'package:ship_conquest/widgets/screens/minimap/minimap_view.dart';
import '../../../utils/constants.dart';
import '../../miscellaneous/path/route_view.dart';

class MinimapScreen extends StatelessWidget {
  const MinimapScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => Camera()),
            ChangeNotifierProvider(create: (_) => RouteManager())
          ],
          child: const MinimapScreenVisuals(),
      );
}

class MinimapScreenVisuals extends StatelessWidget {
  const MinimapScreenVisuals({super.key});

  @override
  Widget build(BuildContext context) {
    MinimapEvent eventHandler = MinimapEvent(
        camera: context.read<Camera>(),
        minimap: context.read<MinimapProvider>(),
        route: context.read<RouteManager>(),
        shipManager: context.read<ShipManager>(),
        services: context.read<ShipServices>()
    );
    eventHandler.load();

    return Stack(
      children: [
        minimapInterface(eventHandler),
        pathManagementInterfaceHolder(eventHandler),
        closeButton(() => context.pop())
      ],
    );
  }

  Widget minimapInterface(MinimapEvent eventHandler) =>
      Consumer<ShipManager>(
          builder: (_, shipManager, __) =>
              CameraPathController(
                  background: const Color.fromRGBO(51, 56, 61, 1),
                  eventHandler: eventHandler,
                  nodes: shipManager.getShipPositions(eventHandler.scale),
                  child: MinimapView(
                      child: RouteView(
                          hooks: shipManager.getShipPositions(eventHandler.scale),
                          child: const PathView()
                      )
                  )
              )
      );

  Widget pathManagementInterfaceHolder(MinimapEvent eventHandler) =>
      Positioned(
          bottom: 20,
          child: PathManagementInterface(eventHandler: eventHandler)
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