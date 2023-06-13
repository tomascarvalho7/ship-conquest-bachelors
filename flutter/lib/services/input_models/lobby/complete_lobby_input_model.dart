import 'package:ship_conquest/domain/lobby/complete_lobby.dart';

class CompleteLobbyInputModel {
  final String tag;
  final String name;
  final String uid;
  final String username;
  final int creationTime;
  final bool isFavorite;
  final int players;

  CompleteLobbyInputModel.fromJson(Map<String, dynamic> json)
      : tag = json['tag'],
        name = json['name'],
        uid = json['uid'],
        username = json['username'],
        creationTime = json['creationTime'],
        isFavorite = json['isFavorite'],
        players = json['players'];
}

extension ToDomain on CompleteLobbyInputModel {
  CompleteLobby toCompleteLobby() =>
      CompleteLobby(
          tag: tag,
          name: name,
          uid: uid,
          username: username,
          creationTime: creationTime,
          isFavorite: isFavorite,
          players: players
      );
}

