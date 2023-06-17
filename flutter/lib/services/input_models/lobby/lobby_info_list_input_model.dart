import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/lobby/lobby_info.dart';
import 'package:ship_conquest/services/input_models/lobby/lobby_info_input_model.dart';

/// Input model class to hold the information of a list of lobbies
class LobbyInfoListInputModel {
  final List<LobbyInfoInputModel> list;

  // Constructor to deserialize the input model from a JSON map.
  LobbyInfoListInputModel.fromJson(Map<String, dynamic> json)
      : list = List<dynamic>.from(json['lobbies'])
      .map((e) => LobbyInfoInputModel.fromJson(e))
      .toList();
}

// An extension on the [LobbyInfoListInputModel] class to convert it to a [Sequence<LobbyInfo>] object.
extension ToDomain on LobbyInfoListInputModel {
  /// Converts the [LobbyInfoListInputModel] to a [Sequence<LobbyInfo>] object.
  Sequence<LobbyInfo> toLobbiesInfo() =>
      Sequence(data: list).map((value) => value.toLobbyInfo());
}
