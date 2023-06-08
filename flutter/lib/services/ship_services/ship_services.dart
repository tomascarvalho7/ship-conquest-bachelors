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

//all of them need to use the lobby id
abstract class ShipServices {
  FutureEither<ErrorFeedback, Horizon> getNewChunk(int chunkSize, Coord2D coordinates, int sId);

  FutureEither<ErrorFeedback, PlayerStats> getPlayerStatistics();

  FutureEither<ErrorFeedback, Token> signIn(String idToken, String username, String? description);

  FutureEither<ErrorFeedback, Token> logIn(String idToken);

  FutureEither<ErrorFeedback, Minimap> getMinimap();

  // Ship related routes
  FutureEither<ErrorFeedback, Ship> navigateTo(int sId, Sequence<Coord2D> landmarks);
  FutureEither<ErrorFeedback, Ship> getShip(int sId);
  FutureEither<ErrorFeedback, Sequence<Ship>> getUserShips();
  FutureEither<ErrorFeedback, Ship> createNewShip();

  // Lobby related routes
  FutureEither<ErrorFeedback, List<Lobby>> getLobbyList(int skip, int limit, String order, String searchedLobby);
  FutureEither<ErrorFeedback, String> joinLobby(String tag);
  FutureEither<ErrorFeedback, String> createLobby(String name);
  FutureEither<ErrorFeedback, Lobby> getLobby(String tag);

  FutureEither<ErrorFeedback, UserInfo> getPersonalInfo();

  FutureEither<ErrorFeedback, void> logoutUser();

  // Island related routes
  FutureEither<ErrorFeedback, Island> conquestIsland(int sId, int islandId);
  FutureEither<ErrorFeedback, Sequence<Island>> getVisitedIslands();

  Future subscribe(
      void Function(int sid, UnknownEvent event) onEvent,
      void Function(Sequence<Ship> fleet) onFleet
      );

  Future unsubscribe();
}