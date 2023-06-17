import 'package:ship_conquest/domain/lobby/lobby_info.dart';

/// Input model class to hold the information of a lobby
class LobbyInfoInputModel {
  final String tag;
  final String name;
  final String uid;
  final String username;
  final int creationTime;
  final bool isFavorite;
  final int players;

  // Constructor to deserialize the input model from a JSON map.
  LobbyInfoInputModel.fromJson(Map<String, dynamic> json)
      : tag = json['tag'],
        name = json['name'],
        uid = json['uid'],
        username = json['username'],
        creationTime = json['creationTime'],
        isFavorite = json['isFavorite'],
        players = json['players'];
}

// An extension on the [LobbyInfoInputModel] class to convert it to a [LobbyInfo] object.
extension ToDomain on LobbyInfoInputModel {
  /// Converts the [LobbyInfoInputModel] to a [LobbyInfo] object.
  LobbyInfo toLobbyInfo() =>
      LobbyInfo(
          tag: tag,
          name: name,
          uid: uid,
          username: username,
          creationTime: creationTime,
          isFavorite: isFavorite,
          players: players
      );
}

