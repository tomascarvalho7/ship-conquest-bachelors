import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/camera_controller.dart';
import 'package:ship_conquest/providers/game/minimap_controllers/route_controller.dart';
import 'minimap_visuals.dart';

class MinimapScreen extends StatelessWidget {
  const MinimapScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => CameraController()),
            ChangeNotifierProvider(create: (_) => RouteController())
          ],
          child: const MinimapVisuals(),
      );
}