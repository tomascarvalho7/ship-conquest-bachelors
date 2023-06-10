import 'package:flutter/material.dart';
import 'package:ship_conquest/domain/island/utils.dart';
import 'package:ship_conquest/providers/game/global_controllers/statistics_controller.dart';
import 'package:ship_conquest/widgets/screens/game/utils/game_details_slider.dart';

import '../../../../../domain/island/island.dart';
import '../../../../../domain/island/island_presentation.dart';
import '../../../../../providers/game/event_handlers/game_event.dart';

/// [IslandElement] is a Widget to display the details and possible
/// interactions related to a [Island].
///
/// Component of [GameDetailsSlider] Widget.
class IslandElement extends StatelessWidget {
  final bool canConquest;
  final Island island;
  const IslandElement({super.key, required this.canConquest, required this.island});

  @override
  Widget build(BuildContext context) =>
      Container(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.travel_explore, size: 30.0),
                  const SizedBox(width: 20.0),
                  content(context, island),
                ],
              ),
              if (!island.isOwnedByUser()) conquestButton(context, island),
            ],
          )
      );

  /// island element display content component
  Widget content(BuildContext context, Island island) =>
      Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            island.getIslandLabel(),
            style: const TextStyle(
              color: Colors.black54,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            island.getIslandDetails(),
            style: const TextStyle(
              color: Colors.black12,
              decoration: TextDecoration.none,
              fontSize: 12.0,
            ),
          ),
        ],
      );

  /// island element button component
  Widget conquestButton(BuildContext context, Island island) =>
      ElevatedButton(
        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.primary)
        ),
        onPressed: () => canConquest ? GameEvent.conquestIsland(context, island) : null,
        child: const Text('Conquest'),
      );
}