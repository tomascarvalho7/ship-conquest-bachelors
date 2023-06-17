import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/island/island.dart';
import 'package:ship_conquest/domain/island/utils.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/providers/camera_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/statistics_controller.dart';
import 'package:ship_conquest/utils/constants.dart';
import 'package:ship_conquest/widgets/screens/game/utils/elements/add_ship_element.dart';
import 'package:ship_conquest/widgets/screens/game/utils/elements/island_element.dart';
import 'package:ship_conquest/widgets/screens/game/utils/elements/ship_element.dart';


/// Builds all the elements inside the bottom draggable sheet of the game interface
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
      Consumer<StatisticsController>(
          builder: (_, statistics, __) =>
              ListView(
                padding: EdgeInsets.zero,
                controller: controller,
                children: [
                  const SizedBox(height: 10),
                  buildDragHandle(),
                  const SizedBox(height: 20),
                  ...nearbyIslands(statistics),
                  ...ownedShips(),
                  AddShipElement(
                      shipCost: shipCost,
                      canBuy: statistics.canMakeTransaction(shipCost),
                      onClick: onShipBuy
                  )
                ],
              )
      );

  /// Builds the drag handle of the slider
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

  /// Builds the islands sections of the slider
  List<Widget> nearbyIslands(StatisticsController statistics) {
    if (islands.isEmpty) return List.empty();

    return [
      listTitle("Nearby Islands"),
      const SizedBox(height: 10),
      ...List.generate(
          islands.length,
              (index) => IslandElement(
                  island: islands.get(index),
                  canConquest: statistics.canMakeTransaction(islands.get(index).conquestCost())
              )
      ),
      const SizedBox(height: 25)
    ];
  }

  /// Builds the ships section of the slider
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

  /// Builds the title of a section, either ships, islands, or any other that might be added
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