/// Enum class to represent a ship's direction.
enum Direction {
  up,
  left,
  down,
  right,
}

/// Retrieves the ship's orientation given the angle [ang].
Direction getOrientationFromAngle(double ang) {
  final angle = ang + 45;
  if (angle > 0 && angle <= 90) return Direction.right;
  if (angle > 90 && angle <= 180) return Direction.down;
  if (angle > 180 && angle <= 270) return Direction.left;
  return Direction.up;
}