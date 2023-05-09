class UserInfoInputModel {
  final String username;
  final String name;
  final String email;
  final String? imageUrl;
  final String? description;

  UserInfoInputModel(
      {required this.username,
      required this.name,
      required this.email,
      required this.imageUrl,
      required this.description});

  UserInfoInputModel.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        name = json['name'],
        email = json['email'],
        imageUrl = json['imageUrl'],
        description = json['description'];
}
