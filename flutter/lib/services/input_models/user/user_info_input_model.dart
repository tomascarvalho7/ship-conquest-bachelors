import 'package:ship_conquest/domain/user/user_info.dart';

/// Input model class representing input data for a user.
class UserInfoInputModel {
  final String username;
  final String name;
  final String email;
  final String? imageUrl;
  final String? description;

  // Constructor to deserialize the input model from a JSON map.
  UserInfoInputModel.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        name = json['name'],
        email = json['email'],
        imageUrl = json['imageUrl'],
        description = json['description'];
}

// An extension on the [UserInfoInputModel] class to convert it to an [UserInfo] domain object.
extension ToDomain on UserInfoInputModel {
  /// Converts the [UserInfoInputModel] to a [UserInfo] object.
  UserInfo toUserInfo() => UserInfo(
      username: username,
      name: name,
      email: email,
      imageUrl: imageUrl,
      description: description
  );
}
