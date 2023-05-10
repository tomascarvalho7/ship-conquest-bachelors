import 'package:flutter/material.dart';

class MinimapIcon extends StatelessWidget {
  final Function() onClick;
  const MinimapIcon({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: onClick,
        child: Icon(
            Icons.map,
            color: Theme.of(context).colorScheme.background
        )
    );
  }
}