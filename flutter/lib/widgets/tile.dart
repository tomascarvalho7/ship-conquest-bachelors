import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/main.dart';

class Tile extends StatelessWidget {
  final Uint8List image;

  const Tile({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
        offset: Offset.zero,
        child: Image.memory(
            image,
          width: tileSize,
          height: tileSize,
        )
    );
  }
}