/// Input model class to hold the result of a favorite lobby request.
class FavoriteLobbyInputModel {
  final bool isFavorite;

  // Constructor to deserialize the input model from a JSON map.
  FavoriteLobbyInputModel.fromJson(Map<String, dynamic> json)
      : isFavorite = json['isFavorite'];
}

// An extension on the [FavoriteLobbyInputModel] class to convert it to a [boolean] value.
extension ToDomain on FavoriteLobbyInputModel {
  /// Converts the [FavoriteLobbyInputModel] to a [boolean] value.
  bool toFavoriteLobby() => isFavorite;
}
