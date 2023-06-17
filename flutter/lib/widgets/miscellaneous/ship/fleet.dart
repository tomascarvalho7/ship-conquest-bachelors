import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/utils/constants.dart';
import 'package:ship_conquest/widgets/miscellaneous/ship/dynamic_ship_widget.dart';
import 'package:ship_conquest/widgets/miscellaneous/ship/ship_widget.dart';
import '../../../providers/game/global_controllers/ship_controller.dart';

/// Widget to represent the main ship, either mobile or static
///
/// - [animation] the wave animation for the ship to follow
class Fleet extends StatelessWidget {
  final Animation<double> animation;
  const Fleet({super.key, required this.animation});

  @override
  Widget build(BuildContext context) =>
      Consumer<ShipController>(
          builder: (_, shipManager, __) => switch (shipManager.getMainShip()) {
            (MobileShip ship) => DynamicShipWidget(
                ship: ship,
                waveAnim: animation,
                tileSize: tileSize
                ),
            (StaticShip ship) => ShipWidget(
                ship: ship,
                waveAnim: animation,
                tileSize: tileSize
                ),
          }
      );
}