
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../providers/camera.dart';
import '../../../providers/global_state.dart';
import '../../../providers/minimap_provider.dart';
import '../../../providers/route_manager.dart';
import '../../../providers/ship_manager.dart';
import '../../../providers/tile_manager.dart';
import '../../../services/ship_services/ship_services.dart';
import 'utils/camera_path_controller.dart';
import '../../miscellaneous/path/path_management_interface.dart';
import '../../miscellaneous/path/path_view.dart';
import '../../miscellaneous/path/route_view.dart';
import 'events/minimap_event.dart';
import 'minimap_view.dart';

class MinimapStateWidget extends StatefulWidget {
  const MinimapStateWidget({super.key});

  @override
  State<StatefulWidget> createState() => MinimapScreenState();
}

class MinimapScreenState extends State<MinimapStateWidget> {
  late final MinimapEvent eventHandler;
  late final timer = Timer.periodic(const Duration(seconds: 2), (_) => eventHandler.lookAround());

  @override
  void initState() {
    super.initState();
    eventHandler = MinimapEvent(
        state: context.read<GlobalState>(),
        camera: context.read<Camera>(),
        minimap: context.read<MinimapProvider>(),
        route: context.read<RouteManager>(),
        shipManager: context.read<ShipManager>(),
        tileManager: context.read<TileManager>(),
        services: context.read<ShipServices>()
    );
    eventHandler.load();
    final t = timer;
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      minimapInterface(eventHandler),
      pathManagementInterfaceHolder(eventHandler),
      closeButton(() {
        eventHandler.saveGameData(); // save game data
        context.go('/game'); // return to game screen
      })
    ],
  );

  Widget minimapInterface(MinimapEvent eventHandler) =>
      Consumer<MinimapProvider>(
          builder: (_, minimapProvider, __) =>
              Consumer<ShipManager>(
                  builder: (_, shipManager, __) =>
                      CameraPathController(
                          background: const Color.fromRGBO(51, 56, 61, 1),
                          eventHandler: eventHandler,
                          nodes: shipManager.getShipPositions(eventHandler.scale),
                          child: MinimapView(
                              minimap: minimapProvider.minimap,
                              child: RouteView(
                                  hooks: shipManager.getShipPositions(eventHandler.scale),
                                  child: const PathView()
                              )
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