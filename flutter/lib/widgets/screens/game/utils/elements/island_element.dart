import 'package:flutter/material.dart';

import '../../../../../domain/island/island.dart';
import '../../../../../domain/island/island_presentation.dart';
import '../../../../../providers/game/event_handlers/game_event.dart';

class IslandElement extends StatelessWidget {
  final Island island;
  const IslandElement({super.key, required this.island});

  @override
  Widget build(BuildContext context) =>
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
                style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                    backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.primary)
                ),
                onPressed: () => GameEvent.conquestIsland(context, island),
                child: const Text('Conquest'),
              ),
            ],
          )
      );

}