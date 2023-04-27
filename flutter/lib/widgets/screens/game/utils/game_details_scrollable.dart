import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/island/island_presentation.dart';
import 'package:ship_conquest/providers/tile_manager.dart';

import '../events/game_event.dart';

class GameDetailsScrollable extends StatelessWidget {
  final GameEvent eventHandler;
  // constructor
  const GameDetailsScrollable({super.key, required this.eventHandler});

  static const minChildSize = 0.12;

  @override
  Widget build(BuildContext context) =>
      Consumer<TileManager>(
        builder: (_, tileManager, __) {
         final islands = tileManager.islands;
          return Center(
            child: DraggableScrollableSheet(
              initialChildSize: minChildSize * islands.length,
              minChildSize: minChildSize * islands.length,
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
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: islands.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                    onPressed: () =>
                                        eventHandler.conquestIsland(tileManager.islands.get(index)),
                                    child: const Text('Conquest'),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1.0,
                              color: Colors.grey[300],
                            ),
                          ]
                      );
                    },
                  ),
                );
              },
            ),
          );
        }
      );
}