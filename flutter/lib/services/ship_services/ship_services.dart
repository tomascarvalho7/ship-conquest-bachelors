import 'package:ship_conquest/domain/feedback/error/error_feedback.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/island/island.dart';
import 'package:ship_conquest/domain/lobby/complete_lobby.dart';
import 'package:ship_conquest/domain/patch_notes/patch_notes.dart';
import 'package:ship_conquest/domain/stats/player_stats.dart';

import '../../domain/either/future_either.dart';
import '../../domain/event/unknown_event.dart';
import '../../domain/lobby/lobby.dart';
import '../../domain/minimap.dart';
import '../../domain/ship/ship.dart';
import '../../domain/space/coord_2d.dart';
import '../../domain/horizon.dart';
import '../../domain/user/token.dart';
import '../../domain/user/token_ping.dart';
import '../../domain/user/user_info.dart';

abstract class ShipServices {
  FutureEither<ErrorFeedback, Horizon> getNewChunk(int chunkSize, Coord2D coordinates, int sId);
  FutureEither<ErrorFeedback, Minimap> getMinimap();

  // authentication related routes
  FutureEither<ErrorFeedback, Token> signIn(String idToken, String username, String? description);
  FutureEither<ErrorFeedback, Token> logIn(String idToken);
  FutureEither<ErrorFeedback, TokenPing> checkTokenValidity(String token);
  Future<void> logoutUser();

  // Ship related routes
  FutureEither<ErrorFeedback, Ship> navigateTo(int sId, Sequence<Coord2D> landmarks);
  FutureEither<ErrorFeedback, Ship> getShip(int sId);
  FutureEither<ErrorFeedback, Sequence<Ship>> getUserShips();
  FutureEither<ErrorFeedback, Ship> createNewShip();

  // Lobby related routes
  FutureEither<ErrorFeedback, Sequence<CompleteLobby>> getLobbyList(int skip, int limit, String order, String searchedLobby, String filterType);
  FutureEither<ErrorFeedback, String> joinLobby(String tag);
  FutureEither<ErrorFeedback, String> createLobby(String name);
  FutureEither<ErrorFeedback, Lobby> getLobby(String tag); // i dont think this is even used
  FutureEither<ErrorFeedback, bool> setFavoriteLobby(String tag);
  FutureEither<ErrorFeedback, bool> removeFavoriteLobby(String tag);

  // statistics related routes
  FutureEither<ErrorFeedback, PlayerStats> getPlayerStatistics();
  FutureEither<ErrorFeedback, UserInfo> getPersonalInfo();

  // patch notes routes
  FutureEither<ErrorFeedback, PatchNotes> getPatchNotes();

  // Island related routes
  FutureEither<ErrorFeedback, Island> conquestIsland(int sId, int islandId);
  FutureEither<ErrorFeedback, Sequence<Island>> getVisitedIslands();

  // server sent events related routes
  Future subscribe(
      void Function(int sid, UnknownEvent event) onEvent,
      void Function(Sequence<Ship> fleet) onFleet
  );

  Future unsubscribe();
}