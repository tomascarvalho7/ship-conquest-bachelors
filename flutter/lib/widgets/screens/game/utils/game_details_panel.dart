import 'package:flutter/material.dart';
import 'package:ship_conquest/providers/camera_controller.dart';
import 'package:ship_conquest/widgets/screens/game/utils/elements/add_ship_element.dart';

import '../../../../domain/island/island.dart';
import '../../../../domain/ship/ship.dart';
import '../../../../domain/immutable_collections/sequence.dart';
import 'elements/island_element.dart';
import 'elements/ship_element.dart';

class GameDetailsPanel extends StatelessWidget {
  final ScrollController controller;
  final CameraController camera;
  final Sequence<Island> islands;
  final Sequence<Ship> ships;
  final void Function() onShipBuy;

  const GameDetailsPanel({
    super.key,
    required this.controller,
    required this.camera,
    required this.ships,
    required this.islands,
    required this.onShipBuy
  });

  @override
  Widget build(BuildContext context) =>
      ListView(
        padding: EdgeInsets.zero,
        controller: controller,
        children: [
          const SizedBox(height: 10),
          buildDragHandle(),
          const SizedBox(height: 20),
          ...nearbyIslands(),
          ...ownedShips(),
          AddShipElement(onClick: onShipBuy, shipCost: 50,)
        ],
      );

  Widget buildDragHandle() => Center(
    child: Container(
      width: 45,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10)
      )
    )
  );

  List<Widget> nearbyIslands() {
    if (islands.isEmpty) return List.empty();

    return [
      listTitle("Nearby Islands"),
      const SizedBox(height: 10),
      ...List.generate(
          islands.length,
              (index) => IslandElement(island: islands.get(index))
      ),
      const SizedBox(height: 25)
    ];
  }

  List<Widget> ownedShips() {
    if (ships.isEmpty) return List.empty();

    return [
      listTitle("Your Fleet"),
      const SizedBox(height: 10),
      ...List.generate(
          ships.length,
              (index) => ShipElement(ship: ships.get(index), index: index, cameraController: camera)
      )
    ];
  }

  Widget listTitle(String title) =>
    Stack(
      alignment: Alignment.center,
      children: [
        Divider(
            thickness: 1.5,
            indent: 75,
            endIndent: 75,
            color: Colors.grey[200]
        ),
        Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 26,
                decoration: TextDecoration.none
            ),
        )
      ]
    );
}