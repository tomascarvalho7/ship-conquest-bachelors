import 'package:ship_conquest/domain/either/future_either.dart';
import 'package:ship_conquest/domain/event/unknown_event.dart';
import 'package:ship_conquest/domain/feedback/error/error_feedback.dart';
import 'package:ship_conquest/domain/game/horizon.dart';
import 'package:ship_conquest/domain/game/minimap.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/island/island.dart';
import 'package:ship_conquest/domain/lobby/create_lobby.dart';
import 'package:ship_conquest/domain/lobby/join_lobby.dart';
import 'package:ship_conquest/domain/lobby/lobby.dart';
import 'package:ship_conquest/domain/lobby/lobby_info.dart';
import 'package:ship_conquest/domain/patch_notes/patch_notes.dart';
import 'package:ship_conquest/domain/path/path_points.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';
import 'package:ship_conquest/domain/stats/player_stats.dart';
import 'package:ship_conquest/domain/user/token.dart';
import 'package:ship_conquest/domain/user/token_ping.dart';
import 'package:ship_conquest/domain/user/user_info.dart';


/// Services abstract class that defines functions for other classes to implement.
///
/// These are functions used to manage data exchange with the server or locally for testing purposes.
abstract class ShipServices {

  /// Retrieves a new set of terrain tiles from the server.
  ///
  /// - [chunkSize] parameter specifies the size of the chunk to retrieve.
  /// - [sId] parameter is the identifier of the ship.
  ///
  /// Returns a [FutureEither] that resolves to a [Horizon] object if the operation is successful,
  /// or an [ErrorFeedback] object in case of an error.
  FutureEither<ErrorFeedback, Horizon> getNewChunk(int chunkSize, Coord2D coordinates, int sId);

  /// Retrieves the game's minimap from the server.
  ///
  /// Returns a [FutureEither] that resolves to a [Minimap] object if the operation is successful,
  /// or an [ErrorFeedback] object in case of an error.
  FutureEither<ErrorFeedback, Minimap> getMinimap();

  // authentication related routes
  /// Retrieves the user's token resulting from the sign-in process.
  ///
  /// - [idToken] is the Google Id Token containing useful information about the user.
  /// - [username] is the name of the user to be created.
  /// - [description] is the description of the user, can be null
  ///
  /// Returns a [FutureEither] that resolves to a [Token] object if the operation is successful,
  /// or an [ErrorFeedback] object in case of an error.
  FutureEither<ErrorFeedback, Token> signIn(String idToken, String username, String? description);

  /// Retrieves the user's token resulting from the log-in process.
  ///
  /// - [idToken] is the Google Id Token containing useful information about the user.
  ///
  /// Returns a [FutureEither] that resolves to a [Token] object if the operation is successful,
  /// or an [ErrorFeedback] object in case of an error.
  FutureEither<ErrorFeedback, Token> logIn(String idToken);

  /// Retrieves a response used to check if the login is possible.
  ///
  /// - [token] is the stored user token being tested.
  ///
  /// Returns a [FutureEither] that resolves to a [TokenPing] object if the operation is successful,
  /// or an [ErrorFeedback] object in case of an error.
  FutureEither<ErrorFeedback, TokenPing> checkTokenValidity(String token);

  /// Logs out the user.
  Future<void> logoutUser();

  // Ship related routes
  /// Retrieves the ship information after navigating.
  ///
  /// - [sId] is the identifier of the ship to navigate.
  /// - [start], [mid], [end] are the navigation path control points.
  ///
  /// Returns a [FutureEither] that resolves to a [Ship] object if the operation is successful,
  /// or an [ErrorFeedback] object in case of an error.
  FutureEither<ErrorFeedback, Ship> navigateTo(int sId, Coord2D start, Coord2D mid, Coord2D end);

  /// Retrieves a specific ship's information.
  ///
  /// - [sId] is the identifier of the ship.
  ///
  /// Returns a [FutureEither] that resolves to a [Ship] object if the operation is successful,
  /// or an [ErrorFeedback] object in case of an error.
  FutureEither<ErrorFeedback, Ship> getShip(int sId);

  /// Retrieves each of the fleet's ship information.
  ///
  /// Returns a [FutureEither] that resolves to a [Sequence<Ship>] object if the operation is successful,
  /// or an [ErrorFeedback] object in case of an error.
  FutureEither<ErrorFeedback, Sequence<Ship>> getUserShips();

  /// Retrieves a specific ship's information after it being created.
  ///
  /// Returns a [FutureEither] that resolves to a [Ship] object if the operation is successful,
  /// or an [ErrorFeedback] object in case of an error.
  FutureEither<ErrorFeedback, Ship> createNewShip();

  // Lobby related routes
  /// Retrieves a list of lobbies according to a series of list managing parameters.
  ///
  /// - [skip] is the number of elements of the base list to be skipped.
  /// - [limit] is the size of the list to be returned.
  /// - [order] is the ordering of the list.
  /// - [searchedLobby] is the name of the lobby to be searched.
  /// - [filterType] is the type of the lobbies to be searched, can be "all", "favorite" and "recent"
  ///
  /// Returns a [FutureEither] that resolves to a [Sequence<LobbyInfo>] object if the operation is successful,
  /// or an [ErrorFeedback] object in case of an error.
  FutureEither<ErrorFeedback, Sequence<LobbyInfo>> getLobbyList(int skip, int limit, String order, String searchedLobby, String filterType);

  /// Retrieves the tag and information of the joined lobby.
  ///
  /// - [tag] is the tag of the lobby to be joined.
  ///
  /// Returns a [FutureEither] that resolves to a [JoinLobby] object if the operation is successful,
  /// or an [ErrorFeedback] object in case of an error.
  FutureEither<ErrorFeedback, JoinLobby> joinLobby(String tag);

  /// Retrieves the tag and information of the created lobby.
  ///
  /// - [name] is the name of the lobby to be created.
  ///
  /// Returns a [FutureEither] that resolves to a [CreateLobby] object if the operation is successful,
  /// or an [ErrorFeedback] object in case of an error.
  FutureEither<ErrorFeedback, CreateLobby> createLobby(String name);

  /// Sets a lobby as favorite.
  ///
  /// - [tag] is the tag of the lobby to make favorite.
  ///
  /// Returns a [FutureEither] that resolves to a [bool] object if the operation is successful,
  /// or an [ErrorFeedback] object in case of an error.
  FutureEither<ErrorFeedback, bool> setFavoriteLobby(String tag);

  /// Removes a lobby as favorite.
  ///
  /// - [tag] is the tag of the lobby to remove as favorite.
  ///
  /// Returns a [FutureEither] that resolves to a [bool] object if the operation is successful,
  /// or an [ErrorFeedback] object in case of an error.
  FutureEither<ErrorFeedback, bool> removeFavoriteLobby(String tag);

  // statistics related routes
  /// Retrieves the statistics of the player.
  ///
  /// Returns a [FutureEither] that resolves to a [PlayerStats] object if the operation is successful,
  /// or an [ErrorFeedback] object in case of an error.
  FutureEither<ErrorFeedback, PlayerStats> getPlayerStatistics();

  /// Retrieves the player's profile information.
  ///
  /// Returns a [FutureEither] that resolves to a [UserInfo] object if the operation is successful,
  /// or an [ErrorFeedback] object in case of an error.
  FutureEither<ErrorFeedback, UserInfo> getPersonalInfo();

  // patch notes routes
  /// Retrieves the game's latest patch notes.
  ///
  /// Returns a [FutureEither] that resolves to a [PatchNotes] object if the operation is successful,
  /// or an [ErrorFeedback] object in case of an error.
  FutureEither<ErrorFeedback, PatchNotes> getPatchNotes();

  // Island related routes
  /// Conquest an island.
  ///
  /// - [sId] the ship's identifier
  /// - [islandId] the to be conquered island's identifier
  ///
  /// Returns a [FutureEither] that resolves to a [Island] object if the operation is successful,
  /// or an [ErrorFeedback] object in case of an error.
  FutureEither<ErrorFeedback, Island> conquestIsland(int sId, int islandId);

  /// Retrieves all the visited islands of a player.
  ///
  /// Returns a [FutureEither] that resolves to a [Sequence<Island>] object if the operation is successful,
  /// or an [ErrorFeedback] object in case of an error.
  FutureEither<ErrorFeedback, Sequence<Island>> getVisitedIslands();

  // server sent events related routes
  /// Subscribe to server-sent events.
  Future subscribe(
      void Function(int sid, UnknownEvent event) onEvent,
      void Function(Sequence<Ship> fleet) onFleet
  );

  /// Unsubscribe to server-sent events.
  Future unsubscribe();
}