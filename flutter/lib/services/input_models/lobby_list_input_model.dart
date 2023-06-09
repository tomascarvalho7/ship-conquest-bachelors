import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/lobby.dart';
import 'package:ship_conquest/services/input_models/lobby_input_model.dart';

class LobbyListInputModel {
  final List<LobbyInputModel> list;

  LobbyListInputModel.fromJson(Map<String, dynamic> json)
      : list = List<dynamic>.from(json['lobbies'])
      .map((e) => LobbyInputModel.fromJson(e))
      .toList();
}

extension ToDomain on LobbyListInputModel {
  Sequence<Lobby> toLobbies() =>
      Sequence(data: list).map((value) => value.toLobby());
}
