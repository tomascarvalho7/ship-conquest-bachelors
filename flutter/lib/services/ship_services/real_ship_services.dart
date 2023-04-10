import 'dart:collection';
import 'dart:convert';
import 'dart:ui';
import 'package:ship_conquest/domain/color/color_gradient.dart';
import 'package:ship_conquest/domain/minimap.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';
import 'package:ship_conquest/domain/space/tile_list.dart';
import 'package:ship_conquest/domain/space/coordinate.dart';
import 'package:ship_conquest/domain/token.dart';
import 'package:ship_conquest/services/input_models/chunk_input_model.dart';
import 'package:ship_conquest/services/input_models/minimap_input_model.dart';
import 'package:ship_conquest/services/input_models/token_input_model.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';
import 'package:http/http.dart' as http;

const baseUri = "ccd6-2001-8a0-6e0e-d200-1487-ee3f-76d1-7b0f.ngrok-free.app";
const lobbyId = "itZFTI";

class RealShipServices extends ShipServices {
  @override
  Future<TileList> getNewChunk(int chunkSize, Coordinate coordinates) async {
    int x = coordinates.x + (chunkSize / 2).round() - 1;
    int y = coordinates.y + (chunkSize / 2).round() - 1;
    final queryParameters = {'x': x.toString(), 'y': y.toString()};

    final response = await http.get(Uri.https(baseUri, "$lobbyId/view", queryParameters));

    if (response.statusCode == 200) {
      final res = ChunkInputModel.fromJson(jsonDecode(response.body));
      final resTiles = res.tiles.map((e) {

        return Coordinate(x: e.x, y: e.y, z: e.z);
      }).toList();

      return TileList(tiles: resTiles);
    } else {
      throw Exception("error fetching a new chunk");
    }
  }

  @override
  Future<Token> signIn(String idToken) async {
    final response = await http.post(
        Uri.https(baseUri, "get-token"),
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "idtoken=$idToken"
    );

    if (response.statusCode == 200) {
      final res = TokenInputModel.fromJson(jsonDecode(response.body));
      return res.toToken();
    } else {
      throw Exception("error creating user token");
    }
  }

  @override
  Future<Minimap> getMinimap(Token token, ColorGradient colorGradient) async {

    final response = await http.get(Uri.https(baseUri, "$lobbyId/minimap"));

    if (response.statusCode == 200) {
      final res = MinimapInputModel.fromJson(jsonDecode(response.body));

      final minimap = Minimap(length: res.length, pixels: HashMap<Coord2D, Color>());
      res.points.map((point) => minimap.add(x: point.x, y: point.y + point.z, color: colorGradient.get(point.z) ));
      print(minimap.pixels);
      return minimap;
    } else {
      throw Exception("error fetching a new chunk");
    }
  }
}
