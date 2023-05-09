class LobbyInputModel {
  final String tag;
  final String name;
  final String uid;
  final String username;
  final int creationTime;

  LobbyInputModel(
      {required this.tag,
      required this.name,
      required this.uid,
      required this.username,
      required this.creationTime});

  LobbyInputModel.fromJson(Map<String, dynamic> json)
      : tag = json['tag'],
        name = json['name'],
        uid = json['uid'],
        username = json['username'],
        creationTime = json['creationTime'];
}
