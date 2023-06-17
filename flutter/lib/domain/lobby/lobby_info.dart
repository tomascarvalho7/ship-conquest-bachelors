/// Class holding a lobby's information such as [tag], [name], [uid], [username],
/// [creationTime], [isFavorite] and [players]
class LobbyInfo {
  final String tag; // the lobby's tag
  final String name; // the lobby's name
  final String uid; // the lobby creator's id
  final String username; // the lobby creator's username
  final int creationTime; // the lobby's creation time
  final bool isFavorite; // the lobby's favorite status
  final int players; // the lobby's player count

  LobbyInfo(
      {required this.tag,
      required this.name,
      required this.uid,
      required this.username,
      required this.creationTime,
      required this.isFavorite,
      required this.players});
}
