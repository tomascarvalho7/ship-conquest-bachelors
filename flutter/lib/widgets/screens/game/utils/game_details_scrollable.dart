import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/island/island_presentation.dart';
import 'package:ship_conquest/domain/isometric/isometric.dart';
import 'package:ship_conquest/providers/camera.dart';
import 'package:ship_conquest/providers/ship_manager.dart';
import 'package:ship_conquest/providers/tile_manager.dart';
import 'package:ship_conquest/utils/constants.dart';

import '../events/game_event.dart';

class GameDetailsScrollable extends StatelessWidget {
  final GameEvent eventHandler;

  // constructor
  const GameDetailsScrollable({Key? key, required this.eventHandler})
      : super(key: key);

  static const minChildSize = 0.2;

  @override
  Widget build(BuildContext context) =>
      Consumer2<TileManager, ShipManager>(
          builder: (_, tileManager, shipManager, __) {
        final islands = tileManager.islands;
        final ships = shipManager.ships;

        final camera = Provider.of<Camera>(context);
        final shipScrollController = ScrollController();

        return Center(
          child: DraggableScrollableSheet(
            initialChildSize: minChildSize * (islands.length + ships.length),
            minChildSize: minChildSize * (islands.length + ships.length),
            maxChildSize: 0.6,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Column(children: [
                    Expanded(
                      flex: 0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        controller: scrollController,
                        itemCount: islands.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
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
                                          getIslandLabel(islands.get(index)),
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            decoration: TextDecoration.none,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        const SizedBox(height: 5.0),
                                        Text(
                                          getIslandDetails(islands.get(index)),
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
                                  onPressed: () => eventHandler.conquestIsland(
                                      tileManager.islands.get(index)),
                                  child: const Text('Conquest'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(
                      thickness: 1.0,
                      color: Colors.grey[300],
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        controller: shipScrollController,
                        itemCount: ships.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
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
                                      "Boat nrº ${index + 1}",
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
                                        final position = ships.get(index).getPosition(-globalScale);
                                        camera.setFocus(toIsometric(position)); // TODO nao ta a atualizar logo a camera, maybe é preciso notificar listeners
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
                        },
                      ),
                    ),
                  ]));
            },
          ),
        );
      });
}
