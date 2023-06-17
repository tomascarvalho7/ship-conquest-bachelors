/// Parses a duration string in the format ["mm:ss.SS"].
///
/// Returns a [Duration] object representing the parsed duration.
Duration parseDuration(String durationString) {
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
