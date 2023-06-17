
import 'package:ship_conquest/services/input_models/space/coord_2d_input_model.dart';

/// Input model class representing input data for a ship's movement.
///
/// - [landmarks] the list of points constructing a path if there is one
/// - [coord] the single coordinate in the case the ship is static
/// - [startTime] the start time of the path
/// - [duration] the duration of the path
class MovementInputModel {
  final List<Coord2DInputModel>? landmarks;
  final Coord2DInputModel? coord;
  final String? startTime;
  final String? duration;

  // Constructor to deserialize the input model from a JSON map.
  MovementInputModel.fromJson(Map<String, dynamic> json):
        landmarks = json['points'] != null ? List<dynamic>.from(json['points'])
          .map((e) => Coord2DInputModel.fromJson(e))
          .toList() : null,
        coord = json['coord'] != null ? Coord2DInputModel.fromJson(json['coord']) : null,
        startTime = json['startTime'],
        duration = json['duration'];
}

