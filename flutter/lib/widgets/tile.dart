import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/utils/num_utils.dart';

import '../main.dart';

class Tile extends StatelessWidget {
  final double x;
  final double y;
  final double z;

  const Tile({super.key, required this.x, required this.y, required this.z});

  @override
  Widget build(BuildContext context) {
    int height = z.toInt();//;
    print("z value: $z");
    return Transform.translate(
        offset: Offset(x, y - z),
        child: Image.asset('assets/images/simple_block.png',
            width: tileSize, height: tileSize)

        /*ColorFiltered(
          colorFilter: ColorFilter.mode(
            Color.fromRGBO(height,height,height, 1),
            BlendMode.modulate,
          ),
          child:
        ));*/
    );}
}
/*
Color getBlockColorByHeight(int height) {
  if (height.isBetween(0, 1)) {
    return const Color.fromRGBO(100, 100, 100, 1);
  } else if (height.isBetween(1, 2)) {
    return const Color.fromRGBO(0, 100, 100, 1);
  } else if (height.isBetween(3, 4)) {
    return const Color.fromRGBO(100, 0, 100, 1);
  } else if (height.isBetween(4, 5)) {
    return const Color.fromRGBO(100, 100, 0, 1);
  } else if (height.isBetween(5, 6)) {
    return const Color.fromRGBO(100, 50, 50, 1);
  } else if (height.isBetween(6, 7)) {
    return const Color.fromRGBO(50, 50, 100, 1);
  } else if (height.isBetween(7, 8)) {
    return const Color.fromRGBO(50, 100, 50, 1);
  } else if (height.isBetween(8, 9)) {
    return const Color.fromRGBO(50, 100, 50, 1);
  } else {
    return const Color.fromRGBO(0, 0, 100, 1);
  }
}
*/