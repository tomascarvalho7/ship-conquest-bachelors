import 'dart:convert';

import 'package:ship_conquest/domain/space/cubic_bezier.dart';
import 'package:ship_conquest/services/input_models/cubic_bezier_input_model.dart';

class ShipPathInputModel {
  final List<CubicBezierInputModel> landmarks;
  final DateTime startTime;
  final Duration duration;

  ShipPathInputModel.fromJson(Map<String, dynamic> json)
      : landmarks = List<dynamic>.from(json['landmarks'])
        .map((e) => CubicBezierInputModel.fromJson(e))
        .toList(),
        startTime = DateTime.parse(json['startTime']),
        duration = parseDurationString(json['duration']);
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