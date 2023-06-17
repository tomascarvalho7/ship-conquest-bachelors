import 'package:flutter/material.dart';

/// Builds the minimap floating action button.
class MinimapIcon extends StatelessWidget {
  final Function() onClick;
  const MinimapIcon({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: onClick,
        child: Icon(
            Icons.map,
            size: 30,
            color: Theme.of(context).colorScheme.background
        )
    );
  }
}