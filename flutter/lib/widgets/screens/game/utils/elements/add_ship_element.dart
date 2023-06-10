import 'package:flutter/material.dart';

/// [AddShipElement] is a Widget to display that provides the
/// action to "buy" and thus add a new [Ship] to the fleet
///
/// Component of [GameDetailsSlider] Widget.
class AddShipElement extends StatelessWidget {
  final int shipCost;
  final void Function() onClick;
  final bool canBuy;
  // constructor
  const AddShipElement({
    super.key,
    required this.onClick,
    required this.shipCost,
    required this.canBuy
  });

  @override
  Widget build(BuildContext context) => switch(canBuy) {
    true => GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => confirmDialog(context),
              );
            },
            child: contentCard(context, canBuy),
          ),
    false => contentCard(context, canBuy)
  };

  /// add ship content card component
  Widget contentCard(BuildContext context, bool canBuy) =>
      Card(
        color: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
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
            color: canBuy ? Theme.of(context).colorScheme.background : Colors.grey,
          ),
        ),
      );

  /// confirm dialog component
  AlertDialog confirmDialog(BuildContext context) =>
      AlertDialog(
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
}
