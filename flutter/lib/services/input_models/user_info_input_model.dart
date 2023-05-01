class UserInfoInputModel {
  final String name;
  final String email;
  final String imageUrl;

  UserInfoInputModel({required this.name, required this.email, required this.imageUrl});

  UserInfoInputModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        imageUrl = json['imageUrl'];
}
