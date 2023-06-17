
import 'package:ship_conquest/domain/lobby/lobby.dart';

/// Input model class to hold the most simple information of a lobby
class LobbyInputModel {
  final String tag;
  final String name;
  final String uid;
  final String username;
  final int creationTime;

  // Constructor to deserialize the input model from a JSON map.
  LobbyInputModel.fromJson(Map<String, dynamic> json)
      : tag = json['tag'],
        name = json['name'],
        uid = json['uid'],
        username = json['username'],
        creationTime = json['creationTime'];
}

// An extension on the [LobbyInputModel] class to convert it to a [Lobby] object.
extension ToDomain on LobbyInputModel {
  /// Converts the [LobbyInputModel] to a [Lobby] object.
  Lobby toLobby() =>
      Lobby(
          tag: tag,
          name: name,
          uid: uid,
          username: username,
          creationTime: creationTime
      );
}

