class CreateLobbyInputModel {
  final String tag;
  final String info;

  CreateLobbyInputModel({required this.tag, required this.info});

  CreateLobbyInputModel.fromJson(Map<String, dynamic> json)
      : tag = json['tag'],
        info = json['info'];
}