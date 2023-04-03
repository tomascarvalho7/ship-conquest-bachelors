import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../domain/ship.dart';
import '../../../providers/ship_manager.dart';

class Fleet extends StatelessWidget {
  final Widget Function(Ship ship) widget;
  const Fleet({super.key, required this.widget});

  @override
  Widget build(BuildContext context) =>
      Consumer<ShipManager>(
          builder: (_, shipManager, __) =>
              Stack(
                children: shipManager.buildListFromShips(widget),
              )
      );
}