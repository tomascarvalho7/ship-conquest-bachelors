import '../island/island.dart';

sealed class KnownEvent {
  int get eid;
  DateTime get instant;
}

class FightEvent implements KnownEvent {
  @override
  final int eid;
  @override
  final DateTime instant;
  final bool won;
  // constructor
  FightEvent({required this.eid, required this.instant, required this.won});
}

class IslandEvent implements KnownEvent {
  @override
  final int eid;
  @override
  final DateTime instant;
  final Island island;
  // constructor
  IslandEvent({required this.eid, required this.instant, required this.island});
}