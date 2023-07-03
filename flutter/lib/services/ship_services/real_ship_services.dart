import 'dart:convert';
import 'dart:io';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:ship_conquest/domain/either/either.dart';
import 'package:ship_conquest/domain/either/future_either.dart';
import 'package:ship_conquest/domain/event/unknown_event.dart';
import 'package:ship_conquest/domain/feedback/error/error_feedback.dart';
import 'package:ship_conquest/domain/feedback/error/utils/constants.dart';
import 'package:ship_conquest/domain/game/horizon.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/island/island.dart';
import 'package:ship_conquest/domain/lobby/create_lobby.dart';
import 'package:ship_conquest/domain/lobby/join_lobby.dart';
import 'package:ship_conquest/domain/lobby/lobby_info.dart';
import 'package:ship_conquest/domain/game/minimap.dart';
import 'package:ship_conquest/domain/patch_notes/patch_notes.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';
import 'package:ship_conquest/domain/stats/player_stats.dart';
import 'package:ship_conquest/domain/user/token.dart';
import 'package:ship_conquest/domain/user/token_ping.dart';
import 'package:ship_conquest/domain/user/user_cacheable.dart';
import 'package:ship_conquest/domain/user/user_info.dart';
import 'package:ship_conquest/providers/lobby_storage.dart';
import 'package:ship_conquest/providers/user_storage.dart';
import 'package:ship_conquest/services/input_models/game/horizon_input_model.dart';
import 'package:ship_conquest/services/input_models/game/island_input_model.dart';
import 'package:ship_conquest/services/input_models/game/islands_input_model.dart';
import 'package:ship_conquest/services/input_models/game/player_stats_input_model.dart';
import 'package:ship_conquest/services/input_models/lobby/create_lobby_input_model.dart';
import 'package:ship_conquest/services/input_models/lobby/lobby_info_list_input_model.dart';
import 'package:ship_conquest/services/input_models/lobby/favorite_lobby_input_model.dart';
import 'package:ship_conquest/services/input_models/lobby/join_lobby_input_model.dart';
import 'package:ship_conquest/services/input_models/game/minimap_input_model.dart';
import 'package:ship_conquest/services/input_models/notification/event_notification_input_model.dart';
import 'package:ship_conquest/services/input_models/patch_notes/patch_notes_input_model.dart';
import 'package:ship_conquest/services/input_models/problem/problem_input_model.dart';
import 'package:ship_conquest/services/input_models/ship/ship_input_model.dart';
import 'package:ship_conquest/services/input_models/ship/ships_input_model.dart';
import 'package:ship_conquest/services/input_models/spring_error_input_model.dart';
import 'package:ship_conquest/services/input_models/user/token_input_model.dart';
import 'package:ship_conquest/services/input_models/user/token_ping_input_model.dart';
import 'package:ship_conquest/services/input_models/user/user_info_input_model.dart';
import 'package:ship_conquest/services/output_models/coord_2d_output_model.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';
import 'package:http/http.dart' as http;
import 'package:ship_conquest/services/utils/event_model.dart';

import '../output_models/navigation_path_output_model.dart';

const baseUri = "b1d5-2001-8a0-6e2e-ba00-c82e-824d-5ecf-9f6b.ngrok-free.app";

class RealShipServices extends ShipServices {
  final UserStorage userStorage;
  final LobbyStorage lobbyStorage;
  // constructor
  RealShipServices({required this.userStorage, required this.lobbyStorage});

  @override
  FutureEither<ErrorFeedback, Horizon> getNewChunk(int chunkSize, Coord2D coordinates, int sId) async {
    final res = await getStorageVariables();
    if (res.isLeft) return Left(res.left);
    final (token, lobbyId) = res.right;

    final response = await http.get(
        Uri.https(baseUri, "$lobbyId/view", {'shipId': sId.toString()}),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });

    return handleResponse(response, (json) =>
      HorizonInputModel.fromJson(json).toHorizon()
    );
  }

  @override
  FutureEither<ErrorFeedback, Token> signIn(String idToken, String username, String? description) async {
    Map<String, dynamic> jsonBody = {
      'idtoken': idToken,
      'username': username,
      'description': description
    };

    final response = await http.post(Uri.https(baseUri, "create-user"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(jsonBody));

    return handleResponse(response, (json) =>
        TokenInputModel.fromJson(json).toToken()
    );
  }

  @override
  FutureEither<ErrorFeedback, Token> logIn(String idToken) async {
    final response = await http.post(Uri.https(baseUri, "get-token"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: "idtoken=$idToken");

    return handleResponse(response, (json) =>
        TokenInputModel.fromJson(json).toToken()
    );
  }

  @override
  FutureEither<ErrorFeedback, TokenPing> checkTokenValidity(String token) async {
    final response = await http.post(Uri.https(baseUri, "check-token"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    return handleResponse(response, (json) =>
        TokenPingInputModel.fromJson(json).toTokenPing()
    );
  }

  @override
  FutureEither<ErrorFeedback, Minimap> getMinimap() async {
    final res = await getStorageVariables();
    if (res.isLeft) return Left(res.left);
    final (token, lobbyId) = res.right;

    final response = await http.get(Uri.https(baseUri, "$lobbyId/minimap"),
    headers: {HttpHeaders.authorizationHeader: 'Bearer $token'} );

    return handleResponse(response, (json) =>
      MinimapInputModel.fromJson(json).toMinimap()
    );
  }

  @override
  FutureEither<ErrorFeedback, Ship> navigateTo(int sId, Coord2D start, Coord2D mid, Coord2D end) async {
    final res = await getStorageVariables();
    if (res.isLeft) return Left(res.left);
    final (token, lobbyId) = res.right;

    final json = NavigationPathOutputModel(start: start, mid: mid, end: end).toJson();

    final response = await http.post(
        Uri.https(baseUri, "$lobbyId/navigate", {'shipId': sId.toString()}),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(json));

    return handleResponse(response, (json) =>
      ShipInputModel.fromJson(json).toShip()
    );
  }

  @override
  FutureEither<ErrorFeedback, Ship> getShip(int sId) async {
    final res = await getStorageVariables();
    if (res.isLeft) return Left(res.left);
    final (token, lobbyId) = res.right;

    final response = await http.get(
        Uri.https(baseUri, "$lobbyId/ship", {'shipId': sId.toString()}),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });

    return handleResponse(response, (json) =>
      ShipInputModel.fromJson(json).toShip()
    );
  }

  @override
  FutureEither<ErrorFeedback, Sequence<Ship>> getUserShips() async {
    final res = await getStorageVariables();
    if (res.isLeft) return Left(res.left);
    final (token, lobbyId) = res.right;

    final response =
        await http.get(Uri.https(baseUri, "$lobbyId/ships"), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });

    return handleResponse(response, (json) =>
      ShipsInputModel.fromJson(json).toSequenceOfShips()
    );
  }

  @override
  FutureEither<ErrorFeedback, Ship> createNewShip() async {
    final res = await getStorageVariables();
    if (res.isLeft) return Left(res.left);
    final (token, lobbyId) = res.right;

    final response = await http.post(
      Uri.https(baseUri, "$lobbyId/ship/add"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: 'Bearer $token',
      }
    );

    return handleResponse(response, (json) =>
      ShipInputModel.fromJson(json).toShip()
    );
  }

  @override
  FutureEither<ErrorFeedback, Sequence<LobbyInfo>> getLobbyList(
      int skip,
      int limit,
      String order,
      String searchedLobby,
      String filterType
      ) async {
    final String? token = await userStorage.getToken();
    if (token == null) return const Left(tokenNotFound);

    final Map<String, String> queryParams = {
      'skip': skip.toString(),
      'limit': limit.toString(),
      'order': order,
      'name': searchedLobby
    };

    final response = await http.get(Uri.https(baseUri, "lobbies/$filterType", queryParams),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});

    return handleResponse(response, (json) =>
        LobbyInfoListInputModel.fromJson(json).toLobbiesInfo()
    );
  }

  @override
  FutureEither<ErrorFeedback, JoinLobby> joinLobby(String tag) async {
    final String? token = await userStorage.getToken();
    if (token == null) return const Left(tokenNotFound);

    final response = await http.post(
      Uri.https(baseUri, "$tag/join"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    return handleResponse(response, (json) =>
        JoinLobbyInputModel.fromJson(json).toJoinLobby()
    );
  }

  @override
  FutureEither<ErrorFeedback, CreateLobby> createLobby(String name) async {
    final String? token = await userStorage.getToken();
    if (token == null) return const Left(tokenNotFound);

    final response = await http.post(Uri.https(baseUri, "create-lobby"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode({'name': name}));

    return handleResponse(response, (json) =>
        CreateLobbyInputModel.fromJson(json).toCreatedLobby()
    );
  }

  @override
  FutureEither<ErrorFeedback, bool> setFavoriteLobby(String tag) async {
    final String? token = await userStorage.getToken();
    if (token == null) return const Left(tokenNotFound);

    final response = await http.post(Uri.https(baseUri, "lobby/favorite"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode({'tag': tag}));

    return handleResponse(response, (json) =>
        FavoriteLobbyInputModel.fromJson(json).toFavoriteLobby()
    );
  }

  @override
  FutureEither<ErrorFeedback, bool> removeFavoriteLobby(String tag) async {
    final String? token = await userStorage.getToken();
    if (token == null) return const Left(tokenNotFound);

    final response = await http.post(Uri.https(baseUri, "lobby/unfavorite"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode({'tag': tag}));

    return handleResponse(response, (json) =>
        FavoriteLobbyInputModel.fromJson(json).toFavoriteLobby()
    );
  }

  @override
  FutureEither<ErrorFeedback, UserInfo> getPersonalInfo() async {
    final String? token = await userStorage.getToken();
    if (token == null) return const Left(tokenNotFound);

    final UserInfoCache? user = await userStorage.getUser();
    if (user != null && DateTime.now().isBefore(user.expiryTime)) {
      return Right(user.toUserInfo());
    }

    final response = await http.get(Uri.https(baseUri, "userinfo"), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });

    return handleResponse(response, (json) {
      final userInfo = UserInfoInputModel.fromJson(
          jsonDecode(
              utf8.decode(
                  response.bodyBytes
              )
          )
      ).toUserInfo();
      userStorage.setUser(userInfo, const Duration(minutes: 5));
      return userInfo;
    }
    );
  }

  @override
  FutureEither<ErrorFeedback, PatchNotes> getPatchNotes() async {
    final String? token = await userStorage.getToken();
    if (token == null) return const Left(tokenNotFound);

    final response = await http.get(Uri.https(baseUri, "patch-notes"), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });

    return handleResponse(response, (json) {
      final patchNotes = PatchNotesInputModel.fromJson(
          jsonDecode(
              utf8.decode(
                  response.bodyBytes
              )
          )
      ).toPatchNotes();
      return patchNotes;
    }
    );
  }

  @override
  FutureEither<ErrorFeedback, Island> conquestIsland(int sId, int islandId) async {
    final res = await getStorageVariables();
    if (res.isLeft) return Left(res.left);
    final (token, lobbyId) = res.right;

    final response = await http.post(Uri.https(baseUri, "$lobbyId/conquest"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode({'shipId': sId, 'islandId': islandId}));

    return handleResponse(response, (json) =>
      IslandInputModel.fromJson(json).toIsland()
    );
  }

  @override
  FutureEither<ErrorFeedback, PlayerStats> getPlayerStatistics() async {
    final res = await getStorageVariables();
    if (res.isLeft) return Left(res.left);
    final (token, lobbyId) = res.right;

    final response = await http.get(Uri.https(baseUri, "$lobbyId/statistics"), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });

    return handleResponse(response, (json) =>
      PlayerStatsInputModel.fromJson(json).toPlayerStats()
    );
  }

  @override
  FutureEither<ErrorFeedback, Sequence<Island>> getVisitedIslands() async {
    final res = await getStorageVariables();
    if (res.isLeft) return Left(res.left);
    final (token, lobbyId) = res.right;

    final response = await http.get(Uri.https(baseUri, '$lobbyId/islands/known'),
    headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});

    return handleResponse(response, (json) =>
      IslandsInputModel.fromJson(json).toIslandSequence()
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
  Future subscribe(void Function(int sid, UnknownEvent event) onEvent,
      void Function(Sequence<Ship> fleet) onFleet) async {
    final String? token = await userStorage.getToken();
    if (token == null) throw Exception("couldn't find token");

    final String? lobbyId = await lobbyStorage.getLobbyId();
    if (lobbyId == null) throw Exception("couldn't find lobby");

    SSEClient.subscribeToSSE(
        url: Uri.https(baseUri, "$lobbyId/subscribe").toString(),
        header: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.acceptHeader: "text/event-stream",
          HttpHeaders.cacheControlHeader: "no-cache",
        }).listen((encodedEvent) {
      final data = encodedEvent.data;
      if (data == null) return;

      // decode data to event format
      final event = EventModel.fromTextStream(data);
      if (event == null) return;

      if (event.event == 'event') {
        final (sid, unknownEvent) =
            EventNotificationInputModel.fromJson(jsonDecode(data)).toDomain();
        onEvent(sid, unknownEvent);
      } else if (event.event == 'fleet') {
        onFleet(ShipsInputModel.fromJson(jsonDecode(event.data)).toSequenceOfShips());
      }
    });
  }

  @override
  Future unsubscribe() async {
    final String? token = await userStorage.getToken();
    if (token == null) throw Exception("couldn't find token");

    final String? lobbyId = await lobbyStorage.getLobbyId();
    if (lobbyId == null) throw Exception("couldn't find lobby");

    // fetch unsubscribe
    await http.get(Uri.https(baseUri, "$lobbyId/unsubscribe"), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    // unsubscribe from SSE
    SSEClient.unsubscribeFromSSE();
  }

  /// returns the user Token and the user current LobbyId from
  /// the application internal storage, or a [ErrorFeedback] in
  /// case something goes wrong
  FutureEither<ErrorFeedback, (String, String)> getStorageVariables() async {
    final String? token = await userStorage.getToken();
    if (token == null) return const Left(tokenNotFound);

    final String? lobbyId = await lobbyStorage.getLobbyId();
    if (lobbyId == null) return const Left(lobbyNotFound);

    return Right((token, lobbyId));
  }

  /// handle a http response from the back-end application
  /// on a successful response build a generic [T] input model
  /// on a unsuccessful response build a [ErrorFeedback] from a [ProblemInputModel]
  Either<ErrorFeedback, T> handleResponse<T>(http.Response response, T Function(Map<String, dynamic> json) block) {
    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return Right(block(json)); // successful on status == 200
    } else if (response.statusCode == 401) {
      return Left(SpringErrorInputModel.fromJson(json).toErrorFeedback());
    } else {
      return Left(ProblemInputModel.fromJson(response.statusCode, json).toErrorFeedback()); // unsuccessful on status != 200
    }
  }
}