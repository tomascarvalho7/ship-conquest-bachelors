class CompleteLobby {
  final String tag;
  final String name;
  final String uid;
  final String username;
  final int creationTime;
  final bool isFavorite;
  final int players;

  CompleteLobby(
      {required this.tag,
      required this.name,
      required this.uid,
      required this.username,
      required this.creationTime,
      required this.isFavorite,
      required this.players});
}
