import 'package:ship_conquest/domain/lobby/create_lobby.dart';

/// Input model class representing input data for lobby creation.
class CreateLobbyInputModel {
  final String tag;
  final String info;

  CreateLobbyInputModel({required this.tag, required this.info});
  // Constructor to deserialize the input model from a JSON map.
  CreateLobbyInputModel.fromJson(Map<String, dynamic> json)
      : tag = json['tag'],
        info = json['info'];
}

// An extension on the [CreateLobbyInputModel] class to convert it to a [CreateLobby] value.
extension ToDomain on CreateLobbyInputModel {
  /// Converts the [CreateLobbyInputModel] to a [CreateLobby] value.
  CreateLobby toCreatedLobby() => CreateLobby(tag: tag);
}
