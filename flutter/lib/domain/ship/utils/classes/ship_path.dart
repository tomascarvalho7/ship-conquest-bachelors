import 'dart:math';

import 'package:ship_conquest/domain/space/cubic_bezier.dart';
import 'package:ship_conquest/domain/space/position.dart';
import 'package:ship_conquest/domain/utils/get_time_percentage.dart';

/// Represents a ship Path
/// this data is global and reliable throughout the whole path.
class ShipPath {
  // path landmarks/points
  final List<CubicBezier> landmarks;
  // path start time
  final DateTime startTime;
  // path travelling duration
  final Duration duration;
  // constructor
  ShipPath({required this.landmarks, required this.startTime, required this.duration});
  // optimizations
  late final endTime = startTime.add(duration);

  /// Retrieves a [Position] according to [u]
  Position getPosition(double u) {
    final index = u.floor();
    if (index == landmarks.length) return landmarks.last.p3 * 1.0;

    final n = u % 1;
    return landmarks[index].get(n);
  }

  /// Retrieves a the current ship [Position].
  Position getPositionFromTime() {
    final percentage = getTimePercentage(startTime, endTime);
    return getPosition(percentage * landmarks.length);
  }

  /// Retrieves the ship's angle according to its interpolation value [u].
  double getAngle(double u) {
    final index = u.floor();
    if (index == landmarks.length) return landmarks.last.getAngleAtPoint(1.0);

    final n = u % 1;
    return landmarks[index].getAngleAtPoint(n);
  }

  /// Retrieves the ship's angle according to the time.
  double getAngleFromTime() {
    final percentage = getTimePercentage(startTime, endTime);
    return getAngle(percentage * landmarks.length);
  }

  /// Gets the value from the boat's path position, or the landmarks length value.
  double getStartFromTime() {
    final timeElapsed = DateTime.now().difference(startTime);
    final percentage = timeElapsed.inMilliseconds / duration.inMilliseconds;
    return min(landmarks.length.toDouble(), percentage * landmarks.length);
  }

  /// Retrieves the duration from the current time to the end of the path.
  Duration getCurrentDuration() => endTime.difference(DateTime.now());

  /// Checks if the ship has reached its destination by comparing the
  /// path's end time to the current instant.
  bool hasReachedDestiny() => endTime.isBefore(DateTime.now());
}