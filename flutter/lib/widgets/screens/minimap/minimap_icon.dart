import 'package:flutter/material.dart';

class MinimapIcon extends StatelessWidget {
  final Function() onClick;
  const MinimapIcon({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 40,
      child: FloatingActionButton(
        onPressed: onClick,
        child: const SizedBox(width: 50, height: 50,)
      )
    );
  }
}