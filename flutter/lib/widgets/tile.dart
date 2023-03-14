import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ship_conquest/main.dart';

class Tile extends StatelessWidget {
  final String svg;

  const Tile({super.key, required this.svg});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      svg,
      width: tileSize,
      height: tileSize * 2,
    );
  }
}