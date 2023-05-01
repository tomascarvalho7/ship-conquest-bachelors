import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserStorage {
  late final _storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _storage.read(key: tokenStorageName);
  }

  void setToken(String token) async {
    await _storage.write(key: tokenStorageName, value: token);
  }

  void deleteToken() async {
    await _storage.delete(key: tokenStorageName);
  }

  final String tokenStorageName = "token";
}