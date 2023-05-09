import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ship_conquest/domain/user/user_cacheable.dart';

import '../domain/user/user_info.dart';

class UserStorage {
  late final _storage = const FlutterSecureStorage();

  Future<UserInfoCache?> getUser() async {
    final user = await _storage.read(key: userStorageName);
    return userInfoFromJson(user);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: tokenStorageName);
  }

  void setUser(UserInfo user, Duration validDuration) async {
    final userInfo = UserInfoCache(
        username: user.username,
        name: user.name,
        email: user.email,
        imageUrl: user.imageUrl,
        description: user.description,
        expiryTime: DateTime.now().add(validDuration));

    final userJson = userInfoToJson(userInfo);
    await _storage.write(key: userStorageName, value: userJson);
  }

  void setToken(String token) async {
    await _storage.write(key: tokenStorageName, value: token);
  }

  void deleteToken() async {
    await _storage.delete(key: tokenStorageName);
  }

  void deleteUser() async {
    await _storage.delete(key: userStorageName);
  }

  final String userStorageName = "user";
  final String tokenStorageName = "token";
}

String userInfoToJson(UserInfoCache userInfo) {
  final Map<String, dynamic> data = userInfo.toJson();
  return json.encode(data);
}

UserInfoCache? userInfoFromJson(String? jsonString) {
  if (jsonString == null) return null;

  final Map<String, dynamic> data = json.decode(jsonString);
  return UserInfoCache.fromJson(data);
}
