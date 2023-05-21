import 'dart:collection';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:ship_conquest/domain/immutable_collections/grid.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/island/island.dart';
import 'package:ship_conquest/domain/island/owned_island.dart';
import 'package:ship_conquest/domain/island/wild_island.dart';
import 'package:ship_conquest/domain/minimap.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/domain/ship/ship_path.dart';
import 'package:ship_conquest/domain/stats/player_stats.dart';
import 'package:ship_conquest/domain/user/token.dart';
import 'package:ship_conquest/domain/utils/distance.dart';
import 'package:ship_conquest/providers/lobby_storage.dart';

import '../../domain/event/unknown_event.dart';
import '../../domain/lobby.dart';
import '../../domain/space/coord_2d.dart';
import '../../domain/horizon.dart';
import '../../domain/user/user_info.dart';
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
  Future<Horizon> getNewChunk(int chunkSize, Coord2D coordinates, int sId) async {
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
  Future<Token> signIn(String idToken, String username, String? description) async {
    return Token(token: "FAKE-ID");
  }

  @override
  Future<Minimap> getMinimap() async {
    return Minimap(
      length: 500,
      data: HashMap() // empty map
    );
  }

  @override
  Future<Ship> navigateTo(int sId, Sequence<Coord2D> landmarks) async {
    double distance = 0.0;
    for(int i = 0; i < landmarks.length - 1; i++) {
      final a = landmarks.get(i);
      final b = landmarks.get(i + 1);
      distance += euclideanDistance(a, b);
    }

    return MobileShip(
        sid: sId,
        path: ShipPath(
            landmarks: buildBeziers(landmarks.data),
            startTime: DateTime.now(),
            duration: Duration(seconds: (distance * 10).round())
        ),
        completedEvents: Grid.empty(),
        futureEvents: Grid.empty()
    );
  }

  @override
  Future<List<Lobby>> getLobbyList(int skip, int limit, String order, String searchedLobby) async {
    return List<Lobby>.generate(5, (index) => Lobby(tag: "asd", name: "TestLobby", uid: "1", username: "franciscobarreiras", creationTime: 234324));
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
    return Lobby(tag: "fake_tag", name: "lobby_name", uid: "1", username: "gui17", creationTime: 832231);
  }

  @override
  Future<UserInfo> getPersonalInfo() async {
    return UserInfo(username: "cenas", name: "tomascarvalho", email: "email", imageUrl: null, description: null);
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

  @override
  Future<Token> logIn(String idToken) async {
    return Token(token: "FAKE-ID");
  }

  @override
  Future<Ship?> getShip(int sId) async {
    return StaticShip(
        sid: sId,
        coordinate: Coord2D(x: 25, y: 25),
        completedEvents: Grid.empty(),
        futureEvents: Grid.empty()
    );
  }

  @override
  Future<Sequence<Ship>> getUserShips() async {
    return Sequence(data: [
      StaticShip(
          sid: 0,
          coordinate: Coord2D(x: 25, y: 25),
          completedEvents: Grid.empty(),
          futureEvents: Grid.empty()
      ),
      StaticShip(
          sid: 1,
          coordinate: Coord2D(x: 50, y: 120),
          completedEvents: Grid.empty(),
          futureEvents: Grid.empty()
      ),
    ]
    );
  }

  @override
  Future subscribe(void Function(int sid, UnknownEvent event) onEvent) async {
    return;
  }

  @override
  Future unsubscribe() async {
    return;
  }

  @override
  Future<Sequence<Island>> getVisitedIslands() async =>
      Sequence(data: [
        WildIsland(id: 1, coordinate: Coord2D(x: 10, y: 10), radius: 25)
    ]);
}

