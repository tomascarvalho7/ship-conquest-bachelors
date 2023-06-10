import 'package:ship_conquest/services/input_models/coord_2d_input_model.dart';

import '../../domain/island/island.dart';

class IslandInputModel {
  final int id;
  final Coord2DInputModel coordinate;
  final int radius;
  final String? username;
  final bool? owned;
  final int? incomePerHour;

  IslandInputModel.fromJson(Map<String, dynamic> json)
    : coordinate = Coord2DInputModel.fromJson(json['origin']),
      id = json['id'],
      radius = json['radius'],
      username = json['username'],
      owned = json['owned'],
      incomePerHour = json['incomePerHour'];
}

extension ToDomain on IslandInputModel {
  Island toIsland() {
    final userName = username;
    final income = incomePerHour;
    final ownership = owned;
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