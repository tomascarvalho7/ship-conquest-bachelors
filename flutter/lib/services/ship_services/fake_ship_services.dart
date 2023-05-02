import 'dart:collection';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:ship_conquest/domain/color/color_gradient.dart';
import 'package:ship_conquest/domain/island/island.dart';
import 'package:ship_conquest/domain/island/owned_island.dart';
import 'package:ship_conquest/domain/minimap.dart';
import 'package:ship_conquest/domain/ship/ship_path.dart';
import 'package:ship_conquest/domain/space/position.dart';
import 'package:ship_conquest/domain/stats/player_stats.dart';
import 'package:ship_conquest/domain/token.dart';
import 'package:ship_conquest/domain/utils/distance.dart';
import 'package:ship_conquest/providers/lobby_storage.dart';

import '../../domain/lobby.dart';
import '../../domain/space/coord_2d.dart';
import '../../domain/horizon.dart';
import '../../domain/user_info.dart';
import '../../domain/utils/build_bezier.dart';
import '../../providers/user_storage.dart';
import '../input_models/horizon_input_model.dart';
import 'ship_services.dart';

class FakeShipServices extends ShipServices {
  final UserStorage userStorage;
  final LobbyStorage lobbyStorage;
  FakeShipServices({required this.userStorage, required this.lobbyStorage});
  bool _conquested = false;

  @override
  Future<Horizon> getNewChunk(int chunkSize, Coord2D coordinates) async {
    if (euclideanDistance(coordinates, Coord2D(x: 10, y: 10)) > 20) {
      return Horizon(tiles: [], islands: []); // return empty list, so only water tiles will be rendered
    }

    final content = await rootBundle.loadString('assets/miscellaneous/fake_island.txt');

    final res = HorizonInputModel
        .fromJson(jsonDecode(content))
        .toHorizon();

    if (!_conquested) return res;

    return Horizon(
        tiles: res.tiles,
        islands: res.islands.map((island) =>
          OwnedIsland(
              id: island.id,
              coordinate: island.coordinate,
              radius: island.radius,
              incomePerHour: 25,
              uid: 'FAKE-UID'
          )
        ).toList()
    );
  }

  @override
  Future<Token> signIn(String idToken) async {
    return Token(token: "FAKE-ID");
  }

  @override
  Future<Minimap> getMinimap(ColorGradient colorGradient) async {
    return Minimap(
      length: 500,
      data: HashMap() // empty map
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
  Future<Position> getMainShipLocation() async {
    return const Position(x: 30, y: 30);
  }

  @override
  Future<List<Lobby>> getAllLobbies() async {
    return List<Lobby>.generate(10, (index) => Lobby(tag: "asd", name: "TestLobby"));
  }

  @override
  Future<String> joinLobby(String tag) async {
    return "Joined";
  }

  @override
  Future<String> createLobby(String name) async {
    return "Created";
  }

  @override
  Future<Lobby> getLobby(String tag) async {
    return Lobby(tag: "fake_tag", name: "lobby_name");
  }

  @override
  Future<UserInfo> getPersonalInfo() async {
    return UserInfo(name: "name", email: "email", imageUrl: "imageUrl");
  }

  @override
  Future<Island> conquestIsland(int sId, int islandId) async {
    _conquested = true;
    return OwnedIsland(
        id: sId,
        coordinate: Coord2D(x: 10, y: 10),
        radius: 30,
        incomePerHour: 25,
        uid: 'FAKE-UID'
    );
  }

  @override
  Future<PlayerStats> getPlayerStatistics() async {
    return PlayerStats(currency: 125, maxCurrency: 600);
  }
}

