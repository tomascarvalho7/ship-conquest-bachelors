import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../domain/ship/ship.dart';
import '../../../providers/game/global_controllers/ship_controller.dart';

class Fleet extends StatelessWidget {
  final Widget Function(Ship ship) widget;
  const Fleet({super.key, required this.widget});

  @override
  Widget build(BuildContext context) =>
      Consumer<ShipController>(
          builder: (_, shipManager, __) =>
              Stack(
                children: shipManager.buildListFromShips(widget),
              )
      );
}