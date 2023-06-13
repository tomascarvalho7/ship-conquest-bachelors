class FavoriteLobbyInputModel {
  final bool isFavorite;

  FavoriteLobbyInputModel.fromJson(Map<String, dynamic> json)
      : isFavorite = json['isFavorite'];
}

extension ToDomain on FavoriteLobbyInputModel {
  bool toFavoriteLobby() => isFavorite;
}
