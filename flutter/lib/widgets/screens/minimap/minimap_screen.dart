import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/camera.dart';
import 'package:ship_conquest/providers/path_manager.dart';
import 'package:ship_conquest/providers/ship_manager.dart';
import 'package:ship_conquest/widgets/miscellaneous/path/path_controller.dart';
import 'package:ship_conquest/widgets/miscellaneous/ship/ship_icon.dart';
import 'package:ship_conquest/widgets/screens/minimap/minimap_view.dart';

import '../../miscellaneous/camera_control.dart';
import '../../miscellaneous/ship/fleet.dart';

class MinimapScreen extends StatelessWidget {
  const MinimapScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => Camera()),
            ChangeNotifierProvider(create: (_) => PathManager())
          ],
          child: screen(context),
      );

  Widget screen(BuildContext context) =>
      Stack(children: [
          CameraControl(
              background: const Color.fromRGBO(51, 56, 61, 1),
              child: Consumer<ShipManager>(
                builder: (_, shipManager, child) =>
                  Stack(
                      children: [
                        child!, // MinimapView()
                        ...shipManager.buildListFromShips(
                          (ship) => PathController(
                              start: ship.getPosition(),
                              widget: ShipIcon(ship: ship)
                          )
                        )
                      ]
                  ),
                  child: const Center(child: MinimapView())
              )
          ),
          closeButton(() => context.pop())
        ],
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