import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/space/position.dart';

class Anchor extends StatelessWidget {
  final Position position;
  final Color color;
  final void Function(DragUpdateDetails) onPan;
  const Anchor({super.key, required this.position, required this.color, required this.onPan});

  static const double size = 25;

  @override
  Widget build(BuildContext context) =>
      GestureDetector(
          onPanUpdate: onPan,
          child: Center(
              child: Transform.translate(
                  offset: position.toOffset(),
                  child: Container( // invisible container that acts as a hitbox
                        color: const Color.fromRGBO(0, 0, 0, 0),
                        child: circularContainer()
                      )
                  )
              )
            );

  Widget circularContainer() =>
      Padding(
        padding: const EdgeInsets.all(size * 3),
        child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle
            )
        )
      );
}