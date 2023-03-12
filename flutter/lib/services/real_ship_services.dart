import 'dart:convert';

import 'package:ship_conquest/domain/chunk.dart';
import 'package:ship_conquest/domain/coordinate.dart';
import 'package:ship_conquest/services/input_models/chunk_input_model.dart';
import 'package:ship_conquest/services/ship_services.dart';
import 'package:http/http.dart' as http;

const baseUri = "1a6a-2001-8a0-6e0e-d200-34c2-7d53-df53-4089.eu.ngrok.io";
const lobbyId = "tjagZ8";

class RealShipServices extends ShipServices {
  @override
  Future<Chunk> getNewChunk(int chunkSize, Coordinate coordinates) async {
    final queryParameters = {'x': 403.toString(), 'y': 452.toString()};

    final response = await http.get(Uri.http(baseUri, "$lobbyId/view", queryParameters));

    if (response.statusCode == 200) {
      final res = ChunkInputModel.fromJson(jsonDecode(response.body));
      final resTiles = res.tiles.map((e) {
        print("tile: $e");
        return Coordinate(x: e.x, y: e.y, z: e.z);
      }).toList();

      return Chunk(size: chunkSize, coordinates: coordinates, tiles: resTiles);
    } else {
      throw Exception("error fetching a new chunk");
    }
  }
}
