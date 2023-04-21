import 'package:ship_conquest/domain/color/color_gradient.dart';
import 'package:ship_conquest/domain/ship/ship_path.dart';
import 'package:ship_conquest/domain/space/position.dart';
import 'package:ship_conquest/domain/space/tile_list.dart';

import '../../domain/minimap.dart';
import '../../domain/space/coord_2d.dart';
import '../../domain/token.dart';

//all of them need to use the lobby id
abstract class ShipServices {
  Future<TileList> getNewChunk(int chunkSize, Coord2D coordinates);

  Future<Token> signIn(String idToken);

  Future<Minimap> getMinimap(ColorGradient colorGradient);

  Future<ShipPath> navigateTo(int sId, List<Coord2D> landmarks);

  Future<Position?> getMainShipPosition();

  Future<ShipPath?> getMainShipPath();
}