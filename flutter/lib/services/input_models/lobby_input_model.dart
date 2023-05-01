class LobbyInputModel {
  final String tag;
  final String name;

  LobbyInputModel({required this.tag, required this.name});

  LobbyInputModel.fromJson(Map<String, dynamic> json)
      : tag = json['tag'],
        name = json['name'];
}
