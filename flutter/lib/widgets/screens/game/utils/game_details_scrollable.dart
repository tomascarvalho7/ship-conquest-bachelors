import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/island/island_presentation.dart';
import 'package:ship_conquest/domain/isometric/isometric.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/providers/camera.dart';
import 'package:ship_conquest/providers/ship_manager.dart';
import 'package:ship_conquest/providers/tile_manager.dart';
import 'package:ship_conquest/utils/constants.dart';

import '../../../../domain/island/island.dart';
import '../events/game_event.dart';

class GameDetailsScrollable extends StatelessWidget {
  final GameEvent eventHandler;

  // constructor
  const GameDetailsScrollable({Key? key, required this.eventHandler})
      : super(key: key);

  static const minChildSize = 0.05;
  static const islandNotificationSize = .1;

  @override
  Widget build(BuildContext context) =>
    Consumer<TileManager>(
      builder: (_, tileManager, __) {
        final islands = tileManager.islands;

        return Consumer2<ShipManager, Camera>(
            builder: (_, shipManager, camera, __) =>
                SizedBox.expand(
                  child: DraggableScrollableSheet(
                    initialChildSize: minChildSize + islandNotificationSize * (islands.length),
                    minChildSize: minChildSize,
                    maxChildSize: 0.5,
                    expand: false,
                    builder: (BuildContext context, ScrollController scrollController) {
                      return Container(
                          margin: const EdgeInsets.only(top: 20),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                          ),
                          child: SafeArea(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    draggableHeaderComponent(),
                                    Expanded(
                                      child: ListView.separated(
                                        itemCount: islands.length,
                                        separatorBuilder: (BuildContext context, int index) => Divider(thickness: 1.0),
                                        itemBuilder: (BuildContext context, int index) =>
                                            islandElement(islands.get(index)),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: shipManager.ships.length,
                                        itemBuilder: (BuildContext context, int index) =>
                                            shipElement(shipManager.ships.get(index), index, camera),
                                      ),
                                    ),
                                  ]
                              )
                          ),
                      );
                    },
                  )
                )
        );
      }
    );

  Widget draggableHeaderComponent() =>
      Container(
        width: 125,
        height: 20,
        decoration: BoxDecoration(
            color: Colors.grey[250],
            borderRadius: const BorderRadius.all(Radius.circular(20))
        ),
      );

  Widget islandElement(Island island) =>
      Container(
        padding: const EdgeInsets.symmetric(
        vertical: 5.0, horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.travel_explore,
                  size: 30.0,
                ),
                const SizedBox(width: 20.0),
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      getIslandLabel(island),
                      style: const TextStyle(
                        color: Colors.black54,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      getIslandDetails(island),
                      style: const TextStyle(
                        color: Colors.black12,
                        decoration: TextDecoration.none,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => eventHandler.conquestIsland(island),
              child: const Text('Conquest'),
            ),
          ],
        )
      );

  Widget shipElement(Ship ship, int index, Camera camera) =>
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
                  style: const TextStyle(
                    color: Colors.black54,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 5.0),
                ElevatedButton.icon(
                  onPressed: () {
                    final position = ship.getPosition(-globalScale);
                    camera.setFocusAndUpdate(toIsometric(position));
                  },
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
