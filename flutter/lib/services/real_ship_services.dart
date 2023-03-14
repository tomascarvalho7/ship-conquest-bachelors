import 'dart:convert';
import 'package:ship_conquest/domain/chunk.dart';
import 'package:ship_conquest/domain/coordinate.dart';
import 'package:ship_conquest/services/input_models/chunk_input_model.dart';
import 'package:ship_conquest/services/ship_services.dart';
import 'package:http/http.dart' as http;

const baseUri = "8634-194-210-199-249.eu.ngrok.io";
const lobbyId = "A9BMdK";

class RealShipServices extends ShipServices {
  @override
  Future<Chunk> getNewChunk(int chunkSize, Coordinate coordinates) async {
    int x = coordinates.x + (chunkSize / 2).round() - 1;
    int y = coordinates.y + (chunkSize / 2).round() - 1;
    final queryParameters = {'x': x.toString(), 'y': y.toString()};
    print("pos: $x - $y");

    final response = await http.get(Uri.http(baseUri, "$lobbyId/view", queryParameters));

    if (response.statusCode == 200) {
      final res = ChunkInputModel.fromJson(jsonDecode(response.body));
      final resTiles = res.tiles.map((e) {

        return Coordinate(x: e.x, y: e.y, z: e.z);
      }).toList();

      return Chunk(size: chunkSize, coordinates: coordinates, tiles: resTiles);
    } else {
      throw Exception("error fetching a new chunk");
    }
  }
}
