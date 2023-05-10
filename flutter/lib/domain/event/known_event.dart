abstract class KnownEvent {}

class FightEvent implements KnownEvent {
  final int eid;
  final DateTime instant;
  final bool won;
  // constructor
  FightEvent({required this.eid, required this.instant, required this.won});
}

class IslandEvent implements KnownEvent {
  final int eid;
  final DateTime instant;
  final int islandId;
  // constructor
  IslandEvent({required this.eid, required this.instant, required this.islandId});
}