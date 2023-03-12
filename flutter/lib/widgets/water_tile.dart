import 'package:flutter/cupertino.dart';

import '../main.dart';

class WaterTile extends StatelessWidget {
  const WaterTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/water_tile.png',
        width: tileSize, height: tileSize);
  }
}
