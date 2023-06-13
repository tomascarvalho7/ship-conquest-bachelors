import '../../../domain/lobby/lobby.dart';

class LobbyInputModel {
  final String tag;
  final String name;
  final String uid;
  final String username;
  final int creationTime;

  LobbyInputModel.fromJson(Map<String, dynamic> json)
      : tag = json['tag'],
        name = json['name'],
        uid = json['uid'],
        username = json['username'],
        creationTime = json['creationTime'];
}

extension ToDomain on LobbyInputModel {
  Lobby toLobby() =>
      Lobby(
          tag: tag,
          name: name,
          uid: uid,
          username: username,
          creationTime: creationTime
      );
}

