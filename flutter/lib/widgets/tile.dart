import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/main.dart';

class Tile extends StatelessWidget {
  final double x;
  final double y;
  final int z;
  final Uint8List image;

  const Tile({super.key, required this.x, required this.y, required this.z, required this.image});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
        offset: Offset(x, y - z),
        child: Image.memory(
            image,
          width: tileSize,
          height: tileSize,
        )
    );
  }
}