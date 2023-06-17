import 'package:ship_conquest/domain/island/island.dart';

/// A sealed class representing a known event.
/// Subclasses of [KnownEvent] must implement the [eid] and [instant] properties.
abstract class KnownEvent {
  /// The unique identifier of the event.
  int get eid;

  /// The instant at which the event occurred.
  DateTime get instant;
}

/// A class representing a fight event, implementing the [KnownEvent] interface.
class FightEvent implements KnownEvent {
  @override
  final int eid;
  @override
  final DateTime instant;
  final bool won;

  // constructor
  FightEvent({required this.eid, required this.instant, required this.won});
}

/// A class representing an island event, implementing the [KnownEvent] interface.
class IslandEvent implements KnownEvent {
  @override
  final int eid;
  @override
  final DateTime instant;
  final Island island;

  // constructor
  IslandEvent({required this.eid, required this.instant, required this.island});
}
