import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ship_conquest/domain/user/user_cacheable.dart';

import '../domain/user/user_info.dart';

///
/// Independent Global Provider with [State] that
/// safely encodes and stores the user [Cache] and
/// credentials like the Back-end [Token].
///
class UserStorage {

  // We're using FlutterSecureStorage instead of regular shared preferences because
  // in this way the data is encrypted and cannot be easily interpreted by third-parties.
  late final _storage = const FlutterSecureStorage();

  /// Retrieves all the cached user information and parses the json into a [UserInfoCache] instance.
  Future<UserInfoCache?> getUser() async {
    final user = await _storage.read(key: _userStorageName);
    return userInfoFromJson(user);
  }

  /// Retrieves the stored token.
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenStorageName);
  }

  /// Retrieves "true" if the user has already logged-in.
  Future<bool> getFirstTime() async {
    return await _storage.read(key: _firstTimeStorageName) == null ? true : false;
  }

  /// Stores the user information as a JSON string.
  /// Expiry time is important because we want to have a validity timeout for the stored information.
  void setUser(UserInfo user, Duration validDuration) async {
    final userInfo = UserInfoCache(
        username: user.username,
        name: user.name,
        email: user.email,
        imageUrl: user.imageUrl,
        description: user.description,
        expiryTime: DateTime.now().add(validDuration));

    await _storage.write(key: _userStorageName, value: userInfoToJson(userInfo));
  }

  /// Sets the firstTime String.
  void setFirstTime() async {
    await _storage.write(key: _firstTimeStorageName, value: "true");
  }

  /// Sets the token as a String.
  void setToken(String token) async {
    await _storage.write(key: _tokenStorageName, value: token);
  }

  /// Deletes the stored token entry.
  void deleteToken() async {
    await _storage.delete(key: _tokenStorageName);
  }

  /// Deletes the stored user entry.
  void deleteUser() async {
    await _storage.delete(key: _userStorageName);
  }

  // storage name constant values
  static const String _userStorageName = "user";
  static const String _tokenStorageName = "token";
  static const String _firstTimeStorageName = "firstTime";
}

/// Converts a [UserInfoCache] object to a JSON string.
///
/// Returns a JSON-encoded string representation of the [UserInfoCache] object.
String userInfoToJson(UserInfoCache userInfo) {
  final Map<String, dynamic> data = userInfo.toJson();
  return json.encode(data);
}

/// Converts a JSON string to a [UserInfoCache] instance.
///
/// Returns a [UserInfoCache] object.
UserInfoCache? userInfoFromJson(String? jsonString) {
  if (jsonString == null) return null;

  final Map<String, dynamic> data = json.decode(jsonString);
  return UserInfoCache.fromJson(data);
}
