import 'package:ship_conquest/domain/color/color_gradient.dart';
import 'package:ship_conquest/domain/island/island.dart';
import 'package:ship_conquest/domain/ship/ship_path.dart';
import 'package:ship_conquest/domain/stats/player_stats.dart';

import '../../domain/lobby.dart';
import '../../domain/minimap.dart';
import '../../domain/space/coord_2d.dart';
import '../../domain/horizon.dart';
import '../../domain/token.dart';
import '../../domain/user_info.dart';

//all of them need to use the lobby id
abstract class ShipServices {
  Future<Horizon> getNewChunk(int chunkSize, Coord2D coordinates);

  Future<PlayerStats> getPlayerStatistics();

  Future<Token> signIn(String idToken);

  Future<Minimap> getMinimap(ColorGradient colorGradient);

  Future<ShipPath> navigateTo(int sId, List<Coord2D> landmarks);

  Future<Object?> getMainShipLocation();

  Future<List<Lobby>> getAllLobbies();

  Future<String> joinLobby(String tag);

  Future<String> createLobby(String name);

  Future<Lobby> getLobby(String tag);

  Future<UserInfo> getPersonalInfo();

  Future<Island> conquestIsland(int sId, int islandId);
}