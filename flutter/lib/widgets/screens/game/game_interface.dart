import 'package:flutter/material.dart';

import 'minimap/minimap_icon.dart';

class GameInterface extends StatelessWidget {
  final Widget gameView;
  final Widget Function() minimapView;
  const GameInterface({super.key, required this.gameView, required this.minimapView});

  @override
  Widget build(BuildContext context) =>
      Stack(
        children: [
          gameView,
          MinimapIcon(
              onClick: () => showDialog(
                  context: context,
                  builder: (context) =>
                      Dialog(
                          insetPadding: const EdgeInsets.all(10),
                          backgroundColor: const Color.fromRGBO(355, 355, 355, .9),
                          child: minimapView(),
                      )
              )
          )
        ]
      );
}