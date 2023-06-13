class JoinLobbyInputModel {
  final String tag;
  final String info;

  JoinLobbyInputModel({required this.tag, required this.info});

  JoinLobbyInputModel.fromJson(Map<String, dynamic> json)
      : tag = json['tag'],
        info = json['info'];
}