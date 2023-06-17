import 'package:ship_conquest/domain/lobby/join_lobby.dart';

/// Input model class to hold the result of a join lobby request.
class JoinLobbyInputModel {
  final String tag;
  final String info;

  JoinLobbyInputModel({required this.tag, required this.info});

  // Constructor to deserialize the input model from a JSON map.
  JoinLobbyInputModel.fromJson(Map<String, dynamic> json)
      : tag = json['tag'],
        info = json['info'];
}

// An extension on the [JoinLobbyInputModel] class to convert it to a [JoinLobby] object.
extension ToDomain on JoinLobbyInputModel {
  /// Converts the [JoinLobbyInputModel] to a [JoinLobby] object.
  JoinLobby toJoinLobby() => JoinLobby(tag: tag, info: info);
}