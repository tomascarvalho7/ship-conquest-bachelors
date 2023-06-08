
import 'package:ship_conquest/domain/event/known_event.dart';

import '../island_input_model.dart';

class KnownEventInputModel {
  final int eid;
  final String instant;
  final bool? won;
  final IslandInputModel? island;

  KnownEventInputModel.fromJson(Map<String, dynamic> json):
      eid = json["eid"],
      instant = json["instant"],
      won = json["won"],
      island = json['island'] != null ? IslandInputModel.fromJson(json['island']) : null;
}

extension ToDomain on KnownEventInputModel {
  KnownEvent toKnownEvent() {
    final wonCast = won;
    final islandCast = island;
    if (wonCast != null) {
      return FightEvent(
          eid: eid,
          instant: DateTime.parse(instant),
          won: wonCast
      );
    } else if (islandCast != null) {
      return IslandEvent(
          eid: eid,
          instant: DateTime.parse(instant),
          island: islandCast.toIsland()
      );
    }

    throw Exception("Invalid Input Model");
  }
}