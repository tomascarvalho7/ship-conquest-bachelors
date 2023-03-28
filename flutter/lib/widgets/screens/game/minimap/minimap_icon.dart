import 'package:flutter/material.dart';

class MinimapIcon extends StatelessWidget {
  final Function() onClick;
  const MinimapIcon({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: FloatingActionButton(
        onPressed: onClick,
        child: Image.network(
          'https://icon-library.com/images/maps-icon-png/maps-icon-png-3.jpg',
          width: 64,
          height: 64,
        )
      )
    );
  }
}