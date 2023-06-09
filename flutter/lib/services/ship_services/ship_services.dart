import 'package:ship_conquest/domain/feedback/error/error_feedback.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/island/island.dart';
import 'package:ship_conquest/domain/stats/player_stats.dart';

import '../../domain/either/future_either.dart';
import '../../domain/event/unknown_event.dart';
import '../../domain/lobby.dart';
import '../../domain/minimap.dart';
import '../../domain/ship/ship.dart';
import '../../domain/space/coord_2d.dart';
import '../../domain/horizon.dart';
import '../../domain/user/token.dart';
import '../../domain/user/user_info.dart';

abstract class ShipServices {
  FutureEither<ErrorFeedback, Horizon> getNewChunk(int chunkSize, Coord2D coordinates, int sId);
  FutureEither<ErrorFeedback, Minimap> getMinimap();

  // authentication related routes
  FutureEither<ErrorFeedback, Token> signIn(String idToken, String username, String? description);
  FutureEither<ErrorFeedback, Token> logIn(String idToken);
  Future<void> logoutUser();

  // Ship related routes
  FutureEither<ErrorFeedback, Ship> navigateTo(int sId, Sequence<Coord2D> landmarks);
  FutureEither<ErrorFeedback, Ship> getShip(int sId);
  FutureEither<ErrorFeedback, Sequence<Ship>> getUserShips();
  FutureEither<ErrorFeedback, Ship> createNewShip();

  // Lobby related routes
  FutureEither<ErrorFeedback, Sequence<Lobby>> getLobbyList(int skip, int limit, String order, String searchedLobby);
  FutureEither<ErrorFeedback, String> joinLobby(String tag);
  FutureEither<ErrorFeedback, String> createLobby(String name);
  FutureEither<ErrorFeedback, Lobby> getLobby(String tag);

  // statistics related routes
  FutureEither<ErrorFeedback, PlayerStats> getPlayerStatistics();
  FutureEither<ErrorFeedback, UserInfo> getPersonalInfo();


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