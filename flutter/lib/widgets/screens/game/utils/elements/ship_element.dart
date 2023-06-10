import 'package:flutter/material.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/providers/camera_controller.dart';
import 'package:ship_conquest/providers/game/event_handlers/game_event.dart';

/// [ShipElement] is a Widget to display the details and possible
/// interactions related to a [Ship].
///
/// Component of [GameDetailsSlider] Widget.
class ShipElement extends StatelessWidget {
  final Ship ship;
  final int index;
  final CameraController cameraController;
  // constructor
  const ShipElement(
      {super.key,
      required this.ship,
      required this.index,
      required this.cameraController});

  @override
  Widget build(BuildContext context) => Card(
        color: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: content(context),
        ),
      );

  /// ship element display content component
  Widget content(BuildContext context) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: Image.asset(
              'assets/images/ship_up.png',
            ),
          ),
          Text("Ship ${index + 1}",
              style: Theme.of(context).textTheme.bodyMedium),
          Column(
            children: [
              GestureDetector(
                onTap: () => GameEvent.selectShip(context, index),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.assistant_navigation,
                    size: 30.0,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              )
            ],
          )
        ],
      );
}
