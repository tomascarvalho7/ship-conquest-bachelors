/// Enum class to represent a ship's direction.
enum Direction {
  north,
  northWest,
  west,
  southWest,
  south,
  southEast,
  east,
  northEast
}

/// Retrieves the ship's orientation given the angle [ang].
Direction getOrientationFromAngle(double ang) {
  final angle = (ang + 90 + 22.5) % 360;
  if (angle > 0 && angle <= 45) return Direction.northEast;
  if (angle > 45 && angle <= 90) return Direction.east;
  if (angle > 90 && angle <= 135) return Direction.southEast;
  if (angle > 135 && angle <= 180) return Direction.south;
  if (angle > 180 && angle <= 225) return Direction.southWest;
  if (angle > 225 && angle <= 270) return Direction.west;
  if (angle > 270 && angle <= 315) return Direction.northWest;
  return Direction.north;
}