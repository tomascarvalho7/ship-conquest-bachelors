import '../space/coord_2d.dart';

/// Represents a closed interface for other classes to implement.
///
/// The [sealed] modifier implies it can only be extended or
/// implemented by classes in the same file.
/// This means it can be exhaustively matched!
sealed class Island {
  int get id;
  Coord2D get coordinate;
  int get radius;
}

/// The [OwnedIsland] class implements the [Island] sealed interface.
///
/// This specialized class represents a [Island] owned by another [User],
/// and thus contains the [Island] and the [User] info.
class OwnedIsland implements Island {
  @override
  final int id;
  @override
  final Coord2D coordinate;
  @override
  final int radius;
  final int incomePerHour;
  final String username;
  final bool owned;
  // constructor
  OwnedIsland({required this.id, required this.coordinate, required this.radius, required this.incomePerHour, required this.username, required this.owned});
}

/// The [WildIsland] class implements the [Island] sealed interface.
///
/// This specialized class represents a wild and unowned island [Island],
/// and thus it simply implement's the [Island] interface.
class WildIsland implements Island {
  @override
  final int id;
  @override
  final Coord2D coordinate;
  @override
  final int radius;
  // constructor
  WildIsland({required this.id, required this.coordinate, required this.radius});
}

