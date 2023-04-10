import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/camera.dart';
import 'package:ship_conquest/providers/route_manager.dart';
import 'package:ship_conquest/providers/ship_manager.dart';
import 'package:ship_conquest/widgets/miscellaneous/path/camera_path_controller.dart';
import 'package:ship_conquest/widgets/miscellaneous/path/path_management_interface.dart';
import 'package:ship_conquest/widgets/miscellaneous/ship/ship_icon.dart';
import 'package:ship_conquest/widgets/screens/minimap/minimap_view.dart';
import '../../../domain/ship.dart';
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
          child: screen(context),
      );

  Widget screen(BuildContext context) {
    return Stack(
      children: [
        const MinimapScreenVisuals(),
        pathManagementInterfaceHolder(),
        closeButton(() => context.pop())
      ],
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

class MinimapScreenVisuals extends StatelessWidget {
  const MinimapScreenVisuals({super.key});

  @override
  Widget build(BuildContext context) {
    RouteManager pathManager = context.read<RouteManager>();

    return Consumer<ShipManager>(
        builder: (_, shipManager, __) =>
            CameraPathController(
                background: const Color.fromRGBO(51, 56, 61, 1),
                pathManager: pathManager,
                nodes: shipManager.getShipPositions(),
                child: MinimapView(
                    child: RouteView(
                        hooks: shipManager.getShipPositions(),
                        child: ShipIcon(ship: Ship(path: []))
                    )
                )
            )
    );
  }

}