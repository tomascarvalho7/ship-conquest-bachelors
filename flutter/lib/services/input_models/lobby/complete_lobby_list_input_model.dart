import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/lobby/complete_lobby.dart';

import 'complete_lobby_input_model.dart';

class CompleteLobbyListInputModel {
  final List<CompleteLobbyInputModel> list;

  CompleteLobbyListInputModel.fromJson(Map<String, dynamic> json)
      : list = List<dynamic>.from(json['lobbies'])
      .map((e) => CompleteLobbyInputModel.fromJson(e))
      .toList();
}

extension ToDomain on CompleteLobbyListInputModel {
  Sequence<CompleteLobby> toCompleteLobbies() =>
      Sequence(data: list).map((value) => value.toCompleteLobby());
}
