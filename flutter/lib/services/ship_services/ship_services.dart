import 'package:ship_conquest/domain/tile_list.dart';
import 'package:ship_conquest/domain/coordinate.dart';

import '../../domain/minimap.dart';
import '../../domain/token.dart';

abstract class ShipServices {
  Future<TileList> getNewChunk(int chunkSize, Coordinate coordinates);

  Future<Token> signIn(String idToken);

  Future<Minimap> getMinimap(Token token);
}