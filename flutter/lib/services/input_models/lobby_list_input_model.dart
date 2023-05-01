import 'package:ship_conquest/services/input_models/lobby_input_model.dart';

class LobbyListInputModel {
  final List<LobbyInputModel> list;

  LobbyListInputModel({required this.list});

  LobbyListInputModel.fromJson(Map<String, dynamic> json)
      : list = List<dynamic>.from(json['lobbies'])
      .map((e) => LobbyInputModel.fromJson(e))
      .toList();
}
