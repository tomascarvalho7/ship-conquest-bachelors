import '../coord_2d_input_model.dart';

class MovementInputModel {
  final List<Coord2DInputModel>? landmarks;
  final Coord2DInputModel? coord;
  final String? startTime;
  final String? duration;

  MovementInputModel.fromJson(Map<String, dynamic> json):
        landmarks = json['points'] != null ? List<dynamic>.from(json['points'])
          .map((e) => Coord2DInputModel.fromJson(e))
          .toList() : null,
        coord = json['coord'] != null ? Coord2DInputModel.fromJson(json['coord']) : null,
        startTime = json['startTime'],
        duration = json['duration'];
}

