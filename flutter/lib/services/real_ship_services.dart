import 'dart:convert';
import 'package:ship_conquest/domain/tile_list.dart';
import 'package:ship_conquest/domain/coordinate.dart';
import 'package:ship_conquest/domain/token.dart';
import 'package:ship_conquest/services/input_models/chunk_input_model.dart';
import 'package:ship_conquest/services/input_models/token_input_model.dart';
import 'package:ship_conquest/services/ship_services.dart';
import 'package:http/http.dart' as http;

const baseUri = "6d06-194-117-18-99.eu.ngrok.io";
const lobbyId = "A9BMdK";

class RealShipServices extends ShipServices {
  @override
  Future<TileList> getNewChunk(int chunkSize, Coordinate coordinates) async {
    int x = coordinates.x + (chunkSize / 2).round() - 1;
    int y = coordinates.y + (chunkSize / 2).round() - 1;
    final queryParameters = {'x': x.toString(), 'y': y.toString()};

    final response = await http.get(Uri.http(baseUri, "$lobbyId/view", queryParameters));

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
        Uri.http(baseUri),
        headers: { "Content-Type": 'application/x-www-form-urlencoded' },
        body: 'idtoken=$idToken'
    );

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      final res = TokenInputModel.fromJson(jsonDecode(response.body));

      return res.toToken();
    } else {
      throw Exception("error creating user token");
    }

    return Token(token: "fake");
  }
}
