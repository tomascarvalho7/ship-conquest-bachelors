/// Class holding a lobby's most simple information such as [tag], [name],
/// [uid], [username] and [creationTime].
class Lobby {
  final String tag;
  final String name;
  final String uid;
  final String username;
  final int creationTime;

  Lobby(
      {required this.tag,
      required this.name,
      required this.uid,
      required this.username,
      required this.creationTime});
}
