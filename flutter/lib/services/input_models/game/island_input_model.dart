import 'package:ship_conquest/domain/island/island.dart';
import 'package:ship_conquest/services/input_models/space/coord_2d_input_model.dart';

/// Input model class representing input data for an island.
class IslandInputModel {
  final int id;
  final Coord2DInputModel coordinate;
  final int radius;
  final String? username;
  final bool? owned;
  final int? incomePerHour;

  // Constructor to deserialize the input model from a JSON map.
  IslandInputModel.fromJson(Map<String, dynamic> json)
    : coordinate = Coord2DInputModel.fromJson(json['origin']),
      id = json['id'],
      radius = json['radius'],
      username = json['username'],
      owned = json['owned'],
      incomePerHour = json['incomePerHour'];
}

// An extension on the [IslandInputModel] class to convert it to an [Island] domain object.
extension ToDomain on IslandInputModel {
  /// Converts the [IslandInputModel] to a [Island] object.
  Island toIsland() {
    // getting the parameters to later check for nullability
    final userName = username;
    final income = incomePerHour;
    final ownership = owned;
    // if username, income and ownership are not null then the island the owned
    // else its a wild island
    if (userName != null && income != null && ownership != null) {
      return OwnedIsland(
        id: id,
        coordinate: coordinate.toCoord2D(),
        radius: radius,
        username: userName,
        owned: ownership,
        incomePerHour: income
      );
    } else {
      return WildIsland(
        id: id,
        coordinate: coordinate.toCoord2D(),
        radius: radius,
      );
    }
  }
}