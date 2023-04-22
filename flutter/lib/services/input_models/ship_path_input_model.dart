import 'package:ship_conquest/services/input_models/coord_2d_input_model.dart';

class ShipPathInputModel {
  final List<Coord2DInputModel> landmarks;
  final DateTime? startTime;
  final Duration? duration;

  ShipPathInputModel.fromJson(Map<String, dynamic> json)
      : landmarks = List<dynamic>.from(json['points'])
            .map((e) => Coord2DInputModel.fromJson(e))
            .toList(),
        startTime = json['startTime'] != null
            ? DateTime.parse(json['startTime'])
            : null,
        duration = json['duration'] != null
            ? parseDurationString(json['duration'])
            : null;
}

Duration parseDurationString(String durationString) {
  final parts = durationString.split(':');
  final minutes = int.parse(parts[0]);
  final seconds = int.parse(parts[1].split('.')[0]);
  final milliseconds = int.parse(parts[1].split('.')[1]);

  return Duration(
    minutes: minutes,
    seconds: seconds,
    milliseconds: milliseconds,
  );
}
