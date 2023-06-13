import 'package:ship_conquest/domain/either/either.dart';
import 'package:ship_conquest/domain/event/known_event.dart';
import 'package:ship_conquest/domain/immutable_collections/grid.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/island/island.dart';
import 'package:ship_conquest/domain/lobby/complete_lobby.dart';
import 'package:ship_conquest/domain/lobby/lobby.dart';
import 'package:ship_conquest/domain/minimap.dart';
import 'package:ship_conquest/domain/patch_notes/patch_note.dart';
import 'package:ship_conquest/domain/patch_notes/patch_notes.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/domain/stats/player_stats.dart';
import 'package:ship_conquest/domain/user/token.dart';
import 'package:ship_conquest/domain/user/token_ping.dart';
import 'package:ship_conquest/domain/utils/distance.dart';
import 'package:ship_conquest/providers/lobby_storage.dart';

import '../../domain/either/future_either.dart';
import '../../domain/event/unknown_event.dart';
import '../../domain/feedback/error/error_feedback.dart';
import '../../domain/ship/utils/classes/ship_path.dart';
import '../../domain/space/coord_2d.dart';
import '../../domain/horizon.dart';
import '../../domain/user/user_info.dart';
import '../../domain/utils/build_bezier.dart';
import '../../providers/user_storage.dart';
import 'ship_services.dart';

class FakeShipServices extends ShipServices {
  final UserStorage userStorage;
  final LobbyStorage lobbyStorage;
  // constructor
  FakeShipServices({required this.userStorage, required this.lobbyStorage});
  int currentId = 3;

  @override
  FutureEither<ErrorFeedback, Horizon> getNewChunk(
      int chunkSize, Coord2D
      coordinates, int sId
      ) async => Right(
          Horizon(tiles: [], islands: [])
      ); // return empty list, so only water tiles will be rendered


  @override
  FutureEither<ErrorFeedback, Token> signIn(
      String idToken,
      String username,
      String? description
      ) async => Right(
        Token(token: "FAKE-ID")
    );

  @override
  FutureEither<ErrorFeedback, TokenPing> checkTokenValidity(String token) async {
    return Right(TokenPing(result: "Successful"));
  }

  @override
  FutureEither<ErrorFeedback, Minimap> getMinimap() async =>
    Right(
        Minimap(
            length: 500,
            data: Grid.empty() // empty map
        )
    );

  @override
  FutureEither<ErrorFeedback, Ship> navigateTo(int sId, Sequence<Coord2D> landmarks) async {
    double distance = 0.0;
    for(int i = 0; i < landmarks.length - 1; i++) {
      final a = landmarks.get(i);
      final b = landmarks.get(i + 1);
      distance += euclideanDistance(a, b);
    }

    return Right(
        MobileShip(
            sid: sId,
            path: ShipPath(
                landmarks: buildBeziers(landmarks.data),
                startTime: DateTime.now(),
                duration: Duration(seconds: (distance * 10).round())
            ),
            completedEvents: Grid.empty(),
            futureEvents: Grid.empty()
        )
    );
  }

  @override
  FutureEither<ErrorFeedback, Sequence<CompleteLobby>> getLobbyList(
      int skip,
      int limit,
      String order,
      String searchedLobby,
      String filterType
      ) async => Right(
        Sequence(data: List.generate(
            5,
                (index) => CompleteLobby(
                tag: "asd",
                name: "TestLobby",
                uid: "1",
                username: "franciscobarreiras",
                creationTime: 234324,
                isFavorite: true,
                players: 1
            )
        )
        )
    );


  @override
  FutureEither<ErrorFeedback, String> joinLobby(String tag) async {
    return const Right("Joined");
  }

  @override
  FutureEither<ErrorFeedback, String> createLobby(String name) async {
    return const Right("Created");
  }

  @override
  FutureEither<ErrorFeedback, Lobby> getLobby(String tag) async {
    return Right(
        Lobby(
            tag: "fake_tag",
            name: "lobby_name",
            uid: "1",
            username: "gui17",
            creationTime: 832231
        )
    );
  }

  @override
  FutureEither<ErrorFeedback, UserInfo> getPersonalInfo() async {
    return Right(
        UserInfo(
            username: "cenas",
            name: "tomascarvalho",
            email: "email",
            imageUrl: null,
            description: null
        )
    );
  }

  @override
  FutureEither<ErrorFeedback, Island> conquestIsland(int sId, int islandId) async {
    return Right(
        OwnedIsland(
            id: sId,
            coordinate: Coord2D(x: 10, y: 10),
            radius: 30,
            incomePerHour: 25,
            username: "tomascarvalho",
            owned: true
        )
    );
  }

  @override
  Future<void> logoutUser() async {
    // delete all user footprint in the app
    userStorage.deleteToken();
    userStorage.deleteUser();
    lobbyStorage.deleteLobbyId();
  }

  @override
  FutureEither<ErrorFeedback, PlayerStats> getPlayerStatistics() async {
    return Right(
        PlayerStats(currency: 125, maxCurrency: 600)
    );
  }

  @override
  FutureEither<ErrorFeedback, Token> logIn(String idToken) async {
    return Right(
        Token(token: "FAKE-ID")
    );
  }

  @override
  FutureEither<ErrorFeedback, Ship> getShip(int sId) async {
    return Right(
        StaticShip(
            sid: sId,
            coordinate: Coord2D(x: 25, y: 25),
            completedEvents: Grid.empty(),
            futureEvents: Grid.empty()
        )
    );
  }

  @override
  FutureEither<ErrorFeedback, Sequence<Ship>> getUserShips() async {
    return Right(
        Sequence(data: [
          StaticShip(
              sid: 0,
              coordinate: Coord2D(x: 25, y: 25),
              completedEvents: Grid(data: { 1 : FightEvent(eid: 1, instant: DateTime.now(), won: true) }),
              futureEvents: Grid.empty()
          ),
          StaticShip(
              sid: 1,
              coordinate: Coord2D(x: 50, y: 120),
              completedEvents: Grid.empty(),
              futureEvents: Grid.empty()
          ),
        ]
        )
    );
  }

  @override
  Future subscribe(
      void Function(int sid, UnknownEvent event) onEvent,
      void Function(Sequence<Ship> fleet) onFleet
      ) async {
    return;
  }

  @override
  Future unsubscribe() async {
    return;
  }

  @override
  FutureEither<ErrorFeedback, Sequence<Island>> getVisitedIslands() async =>
      Right(
          Sequence(data: [
            WildIsland(id: 1, coordinate: Coord2D(x: 10, y: 10), radius: 25)
          ])
      );

  @override
  FutureEither<ErrorFeedback, Ship> createNewShip() async {
    return Right(StaticShip(
        sid: currentId++,
        coordinate: Coord2D(x: 250, y: 75 * currentId),
        completedEvents: Grid.empty(),
        futureEvents: Grid.empty()
    ));
  }

  @override
  FutureEither<ErrorFeedback, bool> setFavoriteLobby(String tag) async {
    return const Right(true);
  }

  @override
  FutureEither<ErrorFeedback, bool> removeFavoriteLobby(String tag) async {
    return const Right(false);
  }

  @override
  FutureEither<ErrorFeedback, PatchNotes> getPatchNotes() async {
    return Right(
        PatchNotes(notes: [
          PatchNote(title: "Version 0.9", details: ["Beta version almost complete", "Try the game now"]),
          PatchNote(title: "Version 0.8", details: ["Beta version under work", "You'll have to wait a bit more"])
        ])
    );
  }
}

