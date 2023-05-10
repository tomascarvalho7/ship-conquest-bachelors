import 'package:flutter/material.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/providers/camera_controller.dart';
import 'package:ship_conquest/providers/game/event_handlers/game_event.dart';
import 'package:ship_conquest/providers/game/event_handlers/minimap_event.dart';

import '../../../../../domain/isometric/isometric.dart';
import '../../../../../utils/constants.dart';

class ShipElement extends StatelessWidget {
  final Ship ship;
  final int index;
  final CameraController cameraController;
  const ShipElement({super.key, required this.ship, required this.index, required this.cameraController});

  @override
  Widget build(BuildContext context) =>
      Container(
        padding: const EdgeInsets.symmetric(
            vertical: 5.0, horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.directions_boat_filled_rounded,
              size: 30.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ship nrº ${index + 1}",
                  style: Theme.of(context).textTheme.bodyMedium
                ),
                const SizedBox(height: 5.0),
                ElevatedButton.icon(
                  style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                    backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.primary)
                  ),
                  onPressed: () => GameEvent.selectShip(context, index),
                  icon: const Icon(
                      Icons.assistant_navigation,
                      size: 30.0),
                  label: const Text("Re-center!"),
                )
              ],
            ),
          ],
        ),
      );

}