import 'dart:collection';

import 'package:ship_conquest/domain/color/color_gradient.dart';
import 'package:ship_conquest/domain/minimap.dart';
import 'package:ship_conquest/domain/space/tile_list.dart';
import 'package:ship_conquest/domain/space/coordinate.dart';
import 'package:ship_conquest/domain/token.dart';

import 'ship_services.dart';

class FakeShipServices extends ShipServices {
  @override
  Future<TileList> getNewChunk(int chunkSize, Coordinate coordinates) {
    // return empty list, so only water tiles will be rendered
    return Future(() => TileList(
        tiles: List.empty()));
  }

  @override
  Future<Token> signIn(String idToken) async {
    return Token(token: "FAKE-ID");
  }

  @override
  Future<Minimap> getMinimap(Token token, ColorGradient colorGradient) async {
    return Minimap(
      length: 500,
      pixels: HashMap() // empty map
    );
  }
}

