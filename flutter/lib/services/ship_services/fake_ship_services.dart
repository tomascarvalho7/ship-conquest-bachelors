import 'dart:collection';

import 'package:ship_conquest/domain/color/color_gradient.dart';
import 'package:ship_conquest/domain/minimap.dart';
import 'package:ship_conquest/domain/ship/ship_path.dart';
import 'package:ship_conquest/domain/space/position.dart';
import 'package:ship_conquest/domain/token.dart';
import 'package:ship_conquest/domain/utils/distance.dart';

import '../../domain/space/coord_2d.dart';
import '../../domain/tile/tile_list.dart';
import '../../domain/utils/build_bezier.dart';
import 'ship_services.dart';

class FakeShipServices extends ShipServices {
  @override
  Future<TileList> getNewChunk(int chunkSize, Coord2D coordinates) {
    // return empty list, so only water tiles will be rendered
    return Future(() => TileList(
        tiles: List.empty()));
  }

  @override
  Future<Token> signIn(String idToken) async {
    return Token(token: "FAKE-ID");
  }

  @override
  Future<Minimap> getMinimap(ColorGradient colorGradient) async {
    return Minimap(
      length: 500,
      pixels: HashMap() // empty map
    );
  }

  @override
  Future<ShipPath> navigateTo(int sId, List<Coord2D> landmarks) async {
    double distance = 0.0;
    for(int i = 0; i < landmarks.length - 1; i++) {
      final a = landmarks[i];
      final b = landmarks[i + 1];
      distance += euclideanDistance(a, b);
    }

    return ShipPath(
        landmarks: buildBeziers(landmarks),
        startTime: DateTime.now(),
        duration: Duration(seconds: (distance * 10).round())
    );
  }

  @override
  Future<Position> getMainShipPosition() async {
    return const Position(x: 30, y: 30);
  }

  @override
  Future<ShipPath> getMainShipPath() async {
    return ShipPath(
        landmarks: List.empty(),
        startTime: DateTime.now(),
        duration: const Duration(seconds: 0)
    );
  }
}

