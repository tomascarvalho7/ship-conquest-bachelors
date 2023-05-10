import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/island/island_presentation.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import '../../../../domain/island/island.dart';
import '../../../../domain/isometric/isometric.dart';

class IslandsView extends StatelessWidget {
  final Sequence<Island> islands;
  // constructor
  const IslandsView({super.key, required this.islands});

  static const height = 350.0;

  @override
  Widget build(BuildContext context) =>
      Stack(
        children: List.generate(
            islands.length,
            (index) => islandIconBuilder(islands.get(index))
        )
      );

  Widget islandIconBuilder(Island island) =>
      Transform.translate(
          offset: toIsometric(island.coordinate.toPosition())
              .toOffset()
              .translate(-150, -height),
          child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              padding: const EdgeInsets.all(16),
              height: 90,
              width: 300,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: getIslandColor(island),
                  borderRadius: const BorderRadius.all(Radius.circular(20))
              ),
              child: Text(
                  getIslandLabel(island),
                  style: const TextStyle(
                      fontSize: 24,
                      color: Color.fromRGBO(255, 255, 255, 1.0),
                      decoration: TextDecoration.none
                  )
              )
          )
      );
}