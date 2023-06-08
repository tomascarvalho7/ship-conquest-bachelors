import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:ship_conquest/domain/color/color_gradient.dart';
import 'package:ship_conquest/domain/either/either.dart';
import 'package:ship_conquest/domain/event/unknown_event.dart';
import 'package:ship_conquest/domain/feedback/error/utils/application_errors.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/island/island.dart';
import 'package:ship_conquest/domain/minimap.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/domain/ship/ship_path.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';
import 'package:ship_conquest/domain/space/position.dart';
import 'package:ship_conquest/domain/stats/player_stats.dart';
import 'package:ship_conquest/domain/user/token.dart';
import 'package:ship_conquest/domain/user/user_cacheable.dart';
import 'package:ship_conquest/domain/utils/build_bezier.dart';
import 'package:ship_conquest/providers/lobby_storage.dart';
import 'package:ship_conquest/providers/user_storage.dart';
import 'package:ship_conquest/services/input_models/horizon_input_model.dart';
import 'package:ship_conquest/services/input_models/island_input_model.dart';
import 'package:ship_conquest/services/input_models/minimap_input_model.dart';
import 'package:ship_conquest/services/input_models/problem/problem_input_model.dart';
import 'package:ship_conquest/services/input_models/token_input_model.dart';
import 'package:ship_conquest/services/output_models/coord_2d_output_model.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';
import 'package:http/http.dart' as http;

import '../../domain/either/future_either.dart';
import '../../domain/feedback/error/error_feedback.dart';
import '../../domain/horizon.dart';
import '../../domain/lobby.dart';
import '../../domain/user/user_info.dart';
import '../input_models/create_lobby_input_model.dart';
import '../input_models/islands_input_model.dart';
import '../input_models/join_lobby_input_model.dart';
import '../input_models/lobby_input_model.dart';
import '../input_models/lobby_list_input_model.dart';
import '../input_models/notification/event_notification_input_model.dart';
import '../input_models/player_stats_input_model.dart';
import '../input_models/ship/ship_input_model.dart';
import '../input_models/ship/ships_input_model.dart';
import '../input_models/user_info_input_model.dart';

const baseUri = "4431-2001-818-dc00-c500-e93c-baa2-63ed-fc8f.ngrok-free.app";

class RealShipServices extends ShipServices {
  final UserStorage userStorage;
  final LobbyStorage lobbyStorage;

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
  FutureEither<ErrorFeedback, Ship> navigateTo(int sId, Sequence<Coord2D> landmarks) async {
    final res = await getStorageVariables();
    if (res.isLeft) return Left(res.left);
    final (token, lobbyId) = res.right;

    Map<String, dynamic> jsonBody = {
      'points': landmarks
          .map((coord) => Coord2DOutputModel(x: coord.x, y: coord.y).toJson())
          .data,
    };

    final response = await http.post(
        Uri.https(baseUri, "$lobbyId/navigate", {'shipId': sId.toString()}),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(jsonBody));

    return handleResponse(response, (json) =>
      ShipInputModel.fromJson(jsonDecode(response.body)).toShip()
    );
  }

  @override
  FutureEither<ErrorFeedback, Ship> getShip(int sId) async {
    final res = await getStorageVariables();
    if (res.isLeft) return Left(res.left);
    final (token, lobbyId) = res.right;

    final response = await http.get(
        Uri.https(baseUri, "$lobbyId/ship", {'shipId': sid.toString()}),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });

    return handleResponse(response, (json) =>
      ShipInputModel.fromJson(jsonDecode(response.body)).toShip()
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
      ShipsInputModel.fromJson(jsonDecode(response.body)).toSequenceOfShips()
    );
  }

  @override
  Future<Ship> createNewShip() async {
    final String? token = await userStorage.getToken();
    if (token == null) throw Exception("couldn't find token");

    final String? lobbyId = await lobbyStorage.getLobbyId();
    if (lobbyId == null) throw Exception("couldn't find lobby");

    final response = await http.post(
      Uri.https(baseUri, "$lobbyId/ship/add"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: 'Bearer $token',
      }
    );

    if (response.statusCode == 200) {
      return ShipInputModel.fromJson(jsonDecode(response.body)).toShip();
    } else {
      throw Exception("error navigating with ship");
    }
  }

  @override
  Future<List<Lobby>> getLobbyList(
      int skip, int limit, String order, String searchedLobby) async {
    final String? token = await userStorage.getToken();
    if (token == null) throw Exception("couldn't find token");

    final Map<String, String> queryParams = {
      'skip': skip.toString(),
      'limit': limit.toString(),
      'order': order,
      'name': searchedLobby
    };

    final response =
        await http.get(Uri.https(baseUri, "lobbies", queryParams), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final res = LobbyListInputModel.fromJson(jsonDecode(response.body));

      return List.generate(
          res.list.length,
          (index) => Lobby(
              tag: res.list[index].tag,
              name: res.list[index].name,
              uid: res.list[index].uid,
              username: res.list[index].username,
              creationTime: res.list[index].creationTime));
    } else {
      throw Exception("error navigating with ship");
    }
  }

  @override
  Future<Lobby> getLobby(String tag) async {
    final String? token = await userStorage.getToken();
    if (token == null) throw Exception("couldn't find token");

    final response =
        await http.get(Uri.https(baseUri, "get-lobby", {'tag': tag}), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final res = LobbyInputModel.fromJson(jsonDecode(response.body));
      return Lobby(
          tag: res.tag,
          name: res.name,
          uid: res.uid,
          username: res.username,
          creationTime: res.creationTime);
    } else {
      throw Exception("error getting lobby");
    }
  }

  @override
  Future<String> joinLobby(String tag) async {
    final String? token = await userStorage.getToken();
    if (token == null) throw Exception("couldn't find token");

    final response = await http.post(
      Uri.https(baseUri, "$tag/join"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final res = JoinLobbyInputModel.fromJson(jsonDecode(response.body));

      return res.tag;
    } else {
      throw Exception("error navigating with ship");
    }
  }

  @override
  Future<String> createLobby(String name) async {
    final String? token = await userStorage.getToken();
    if (token == null) throw Exception("couldn't find token");

    Map<String, dynamic> jsonBody = {
      'name': name,
    };

    final response = await http.post(Uri.https(baseUri, "create-lobby"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(jsonBody));

    if (response.statusCode == 200) {
      final res = CreateLobbyInputModel.fromJson(jsonDecode(response.body));

      return res.tag;
    } else {
      throw Exception("error navigating with ship");
    }
  }

  @override
  Future<UserInfo> getPersonalInfo() async {
    final String? token = await userStorage.getToken();
    if (token == null) throw Exception("couldn't find token");

    final UserInfoCache? user = await userStorage.getUser();
    if (user != null && DateTime.now().isBefore(user.expiryTime)) {
      return user.toUserInfo();
    }

    final response = await http.get(Uri.https(baseUri, "userinfo"), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final res = UserInfoInputModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      final userInfo = UserInfo(
          username: res.username,
          name: res.name,
          email: res.email,
          imageUrl: res.imageUrl,
          description: res.description);
      userStorage.setUser(userInfo, const Duration(minutes: 5));
      return userInfo;
    } else {
      throw Exception("error getting user info");
    }
  }

  @override
  Future<Island> conquestIsland(int sId, int islandId) async {
    final String? token = await userStorage.getToken();
    if (token == null) throw Exception("couldn't find token");

    final String? lobbyId = await lobbyStorage.getLobbyId();
    if (lobbyId == null) throw Exception("couldn't find lobby");

    final response = await http.post(Uri.https(baseUri, "$lobbyId/conquest"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode({'shipId': sId, 'islandId': islandId}));

    if (response.statusCode == 200) {
      return IslandInputModel.fromJson(jsonDecode(response.body)).toIsland();
    } else {
      throw Exception("error conquesting island");
    }
  }

  @override
  Future<PlayerStats> getPlayerStatistics() async {
    final String? token = await userStorage.getToken();
    if (token == null) throw Exception("couldn't find token");

    final String? lobbyId = await lobbyStorage.getLobbyId();
    if (lobbyId == null) throw Exception("couldn't find lobby");

    final response =
        await http.get(Uri.https(baseUri, "$lobbyId/statistics"), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return PlayerStatsInputModel.fromJson(jsonDecode(response.body))
          .toPlayerStats();
    } else {
      throw Exception("error getting player statistics");
    }
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
        }).listen((event) {
      final data = event.data;
      if (data == null) return;

      print(event.event);
      if (event.event == 'event') {
        final (sid, unknownEvent) =
            EventNotificationInputModel.fromJson(jsonDecode(data)).toDomain();

        onEvent(sid, unknownEvent);
      } else if (event.event == 'fleet') {
        onFleet(ShipsInputModel.fromJson(jsonDecode(data)).toSequenceOfShips());
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

  @override
  Future<Sequence<Island>> getVisitedIslands() async {
    final String? token = await userStorage.getToken();
    if (token == null) throw Exception("couldn't find token");

    final String? lobbyId = await lobbyStorage.getLobbyId();
    if (lobbyId == null) throw Exception("couldn't find lobby");

    final response =
        await http.get(Uri.https(baseUri, '$lobbyId/islands/known'), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return IslandsInputModel.fromJson(jsonDecode(response.body))
          .toIslandSequence();
    } else {
      throw Exception("error getting player islands");
    }
  }

  @override
  Future<void> logoutUser() async {
    // delete all user footprint in the app
    userStorage.deleteToken();
    userStorage.deleteUser();
    lobbyStorage.deleteLobbyId();
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
    return response.statusCode == 200
        ? Right(block(json)) // successful on status == 200
        : Left(ProblemInputModel.fromJson(json).toErrorFeedback()); // unsuccessful on status != 200
  }
}