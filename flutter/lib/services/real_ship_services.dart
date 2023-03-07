
import 'dart:convert';

import 'package:ship_conquest/domain/chunk.dart';
import 'package:ship_conquest/domain/coordinate.dart';
import 'package:ship_conquest/services/input_models/chunk_input_model.dart';
import 'package:ship_conquest/services/ship_services.dart';
import 'package:http/http.dart' as http;

const baseUri = "0e2a-2001-8a0-6e0e-d200-4c37-a55d-1f84-a779.eu.ngrok.io";
const lobbyId = "tjagZ8";

class RealShipServices extends ShipServices {
  @override
  Future<Chunk> getNewChunk(int chunkSize, Coordinate coordinates) async {
    final queryParameters = {
      'x' : coordinates.x.toString(),
      'y' : coordinates.y.toString()
    };
    print(coordinates.x.toString());
    print(coordinates.y.toString());

    final response = await http.get(Uri.http(baseUri, "$lobbyId/view", queryParameters));

    if(response.statusCode == 200) {
      print(response.body);
      final res = ChunkInputModel.fromJson(jsonDecode(response.body));
      return res.toChunk(chunkSize, coordinates);
    } else {
      throw Exception("error fetching a new chunk");
    }
  }
}