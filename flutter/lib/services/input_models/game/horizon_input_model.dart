import 'package:ship_conquest/domain/game/horizon.dart';
import 'package:ship_conquest/domain/space/coordinate.dart';
import 'package:ship_conquest/services/input_models/game/island_input_model.dart';
import 'package:ship_conquest/services/input_models/space/coordinate_input_model.dart';

/// Input model class representing input data for the game's horizon request.
class HorizonInputModel {
  final List<CoordinateInputModel> tiles;
  final List<IslandInputModel> islands;
  // constructor
  HorizonInputModel({required this.tiles, required this.islands});

  // Constructor to deserialize the input model from a JSON map.
  HorizonInputModel.fromJson(Map<String, dynamic> json)
    : tiles = List<dynamic>.from(json['tiles'])
      .map((e) => CoordinateInputModel.fromJson(e))
      .toList(),
    islands = List<dynamic>.from(json['islands'])
      .map((e) => IslandInputModel.fromJson(e))
      .toList();
}

// An extension on the [HorizonInputModel] class to convert it to an [Horizon] domain object.
extension Convert on HorizonInputModel {
  /// Converts the [HorizonInputModel] to a [Horizon] object.
  Horizon toHorizon() {
    return Horizon(
        tiles: tiles
            .map((value) => Coordinate(x: value.x, y: value.y, z: value.z))
            .toList(),
        islands: islands
            .map((value) => value.toIsland())
            .toList()
    );
  }
}
