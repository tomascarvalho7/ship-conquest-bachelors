import 'package:ship_conquest/domain/user/user_info.dart';

/// Class representing the user information to be cached in memory.
class UserInfoCache {
  final String username;
  final String name;
  final String email;
  final String? imageUrl;
  final String? description;
  final DateTime expiryTime;

  UserInfoCache(
      {required this.username,
      required this.name,
      required this.email,
      required this.imageUrl,
      required this.description,
      required this.expiryTime});

  /// Convert [UserInfoCache] into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'description': description,
      'expiryTime': expiryTime.toIso8601String()
    };
  }

  /// Convert from a JSON map to a [UserInfoCache] instance.
  factory UserInfoCache.fromJson(Map<String, dynamic> json) {
    return UserInfoCache(
      username: json['username'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        imageUrl: json['imageUrl'] as String?,
        description: json['description'] as String?,
        expiryTime: DateTime.parse(json['expiryTime']));
  }
}

extension UserInfoParsing on UserInfoCache {
  /// Convert a [UserInfoCache] instance into a [UserInfo] instance.
  UserInfo toUserInfo() => UserInfo(
      username: username, name: name, email: email, imageUrl: imageUrl, description: description);
}
