import 'package:flutter/material.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/providers/camera_controller.dart';
import 'package:ship_conquest/providers/game/event_handlers/game_event.dart';

class AddShipElement extends StatelessWidget {
  final int shipCost;
  final void Function() onClick;

  const AddShipElement(
      {super.key, required this.onClick, required this.shipCost});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              title: Text(
                "Confirm operation",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.background,
                    fontSize: 20
                ),
              ),
              content: Text(
                "This operation will cost you $shipCost coins."
                    "\nAre you sure you want to proceed?",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 15
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    onClick();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Confirm"),
                ),
              ],
            );
          },
        );
      },
      child: Card(
        color: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,  // Set the border color
              width: 1.0,          // Set the border width
            ),
            borderRadius: BorderRadius.circular(15.0),  // Set the border radius
          ),
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Icon(
            Icons.add_circle,
            size: 40,
            color: Theme.of(context).colorScheme.background,
          ),
        ),
      ),
    );
  }
}
