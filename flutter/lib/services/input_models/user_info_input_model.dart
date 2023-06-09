import 'package:ship_conquest/domain/user/user_info.dart';

class UserInfoInputModel {
  final String username;
  final String name;
  final String email;
  final String? imageUrl;
  final String? description;

  UserInfoInputModel.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        name = json['name'],
        email = json['email'],
        imageUrl = json['imageUrl'],
        description = json['description'];
}

extension ToDomain on UserInfoInputModel {
  UserInfo toUserInfo() => UserInfo(
      username: username,
      name: name,
      email: email,
      imageUrl: imageUrl,
      description: description
  );
}
