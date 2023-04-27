import 'package:ship_conquest/services/input_models/coord_2d_input_model.dart';

import '../../domain/island/island.dart';
import '../../domain/island/owned_island.dart';
import '../../domain/island/wild_island.dart';

class IslandInputModel {
  final int id;
  final Coord2DInputModel coordinate;
  final int radius;
  final String? uid;
  final int? incomePerHour;

  IslandInputModel.fromJson(Map<String, dynamic> json)
    : coordinate = Coord2DInputModel.fromJson(json['origin']),
      id = json['id'],
      radius = json['radius'],
      uid = json['uid'],
      incomePerHour = json['incomePerHour'];
}

extension ToDomain on IslandInputModel {
  Island toIsland() {
    final userId = uid;
    final income = incomePerHour;
    if (userId != null && income != null) {
      return OwnedIsland(
        id: id,
        coordinate: coordinate.toCoord2D(),
        radius: radius,
        uid: userId,
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