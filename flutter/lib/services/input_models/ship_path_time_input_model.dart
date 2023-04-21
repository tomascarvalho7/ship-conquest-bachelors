class ShipPathTimeInputModel {
  final DateTime startTime;
  final Duration duration;

  ShipPathTimeInputModel.fromJson(Map<String, dynamic> json)
      : startTime = DateTime.parse(json['startTime']),
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