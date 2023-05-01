import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LobbyStorage {
  late final _storage = const FlutterSecureStorage();

  Future<String?> getLobbyId() async {
    return await _storage.read(key: lobbyStorageName);
  }

  void setLobbyId(String lobbyId) async {
    await _storage.write(key: lobbyStorageName, value: lobbyId);
  }

  void deleteLobbyId() async {
    await _storage.delete(key: lobbyStorageName);
  }

  final String lobbyStorageName = "lobby_id";
}