import 'package:ship_conquest/domain/color/color_gradient.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/island/island.dart';
import 'package:ship_conquest/domain/ship/ship_path.dart';
import 'package:ship_conquest/domain/stats/player_stats.dart';

import '../../domain/lobby.dart';
import '../../domain/minimap.dart';
import '../../domain/ship/ship.dart';
import '../../domain/space/coord_2d.dart';
import '../../domain/horizon.dart';
import '../../domain/user/token.dart';
import '../../domain/user/user_info.dart';

//all of them need to use the lobby id
abstract class ShipServices {
  Future<Horizon> getNewChunk(int chunkSize, Coord2D coordinates, int sId);

  Future<PlayerStats> getPlayerStatistics();

  Future<Token> signIn(String idToken, String username, String? description);

  Future<Token> logIn(String idToken);

  Future<Minimap> getMinimap();

  // Ship related routes
  Future<Ship> navigateTo(int sId, Sequence<Coord2D> landmarks);
  Future<Ship?> getShip(int sId);
  Future<Sequence<Ship>> getUserShips();

  // Lobby related routes
  Future<List<Lobby>> getLobbyList(int skip, int limit, String order, String searchedLobby);
  Future<String> joinLobby(String tag);
  Future<String> createLobby(String name);
  Future<Lobby> getLobby(String tag);

  Future<UserInfo> getPersonalInfo();

  Future<Island> conquestIsland(int sId, int islandId);
}