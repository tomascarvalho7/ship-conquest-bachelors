import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserStorage {
  late final storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await storage.read(key: tokenStorageName);
  }

  void setToken(String token) async {
    await storage.write(key: tokenStorageName, value: token);
  }

  void deleteToken() async {
    await storage.delete(key: tokenStorageName);
  }

  final String tokenStorageName = "token";
}