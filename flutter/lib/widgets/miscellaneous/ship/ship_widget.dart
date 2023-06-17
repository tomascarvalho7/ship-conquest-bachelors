import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/isometric/isometric.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/domain/ship/utils/logic.dart';
import 'package:ship_conquest/domain/space/position.dart';
import 'package:ship_conquest/utils/constants.dart';
import 'package:ship_conquest/widgets/miscellaneous/ship/ship_view.dart';
import 'package:ship_conquest/widgets/miscellaneous/ship/utils.dart';


/// Widget representing a static ship.
///
/// - [waveAnim] the animation of the waves
/// - [ship] the ship to be rendered
/// - [tileSize] the size of the tiles, to calculate ship scale
///
/// Builds the ship according to the wave animation and with all its properties.
class ShipWidget extends StatelessWidget {
  final Animation<double> waveAnim;
  final Ship ship;
  final double tileSize;
  // constructor
  ShipWidget({super.key, required this.ship, required this.tileSize, required this.waveAnim});
  // optimizations
  late final position = toIsometric(ship.getPosition(globalScale));
  late final orientation = ship.getDirection();
  late final scale = tileSize * 4;
  late final double waveOffset = (position.x + position.y) / -3;

  @override
  Widget build(BuildContext context) =>
      AnimatedBuilder(
          animation: waveAnim,
          child: ShipView(
            isFighting: ship.isFighting(DateTime.now()),
            scale: scale,
            direction: orientation,
          ),
          builder: (context, child) =>
              Transform.translate(
                  offset: (
                      addWaveHeightToPos(position, waveAnim.value + waveOffset) - Position(x: scale / 2, y: scale / 2)
                  ).toOffset(),
                  child: child
              )
      );
}