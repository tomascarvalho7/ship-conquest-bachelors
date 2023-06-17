import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/lobby/lobby.dart';
import 'package:ship_conquest/services/input_models/lobby/lobby_input_model.dart';

/// Input model class to hold the most simple information of a list of lobbies
class LobbyListInputModel {
  final List<LobbyInputModel> list;

  // Constructor to deserialize the input model from a JSON map.
  LobbyListInputModel.fromJson(Map<String, dynamic> json)
      : list = List<dynamic>.from(json['lobbies'])
      .map((e) => LobbyInputModel.fromJson(e))
      .toList();
}

// An extension on the [LobbyListInputModel] class to convert it to a [Sequence<Lobby>] object.
extension ToDomain on LobbyListInputModel {
  /// Converts the [LobbyListInputModel] to a [Sequence<Lobby>] object.
  Sequence<Lobby> toLobbies() =>
      Sequence(data: list).map((value) => value.toLobby());
}
