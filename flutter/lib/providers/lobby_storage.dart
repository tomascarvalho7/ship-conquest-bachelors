import 'package:flutter_secure_storage/flutter_secure_storage.dart';

///
/// Independent Global Provider with [State] that
/// safely encodes and stores the user's current [LobbyId].
///
class LobbyStorage {

  // We're using FlutterSecureStorage instead of regular shared preferences because
  // in this way the data is encrypted and cannot be easily interpreted by third-parties.
  late final _storage = const FlutterSecureStorage();

  /// Gets the id of the currently stored lobby.
  Future<String?> getLobbyId() async {
    return await _storage.read(key: _lobbyStorageName);
  }

  /// Sets the [lobbyId] to be stored.
  void setLobbyId(String lobbyId) async {
    await _storage.write(key: _lobbyStorageName, value: lobbyId);
  }

  /// Deletes the current lobby id entry.
  void deleteLobbyId() async {
    await _storage.delete(key: _lobbyStorageName);
  }

  final String _lobbyStorageName = "lobby_id";
}