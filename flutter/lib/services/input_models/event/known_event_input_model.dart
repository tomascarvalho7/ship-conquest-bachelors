
import 'package:ship_conquest/domain/event/known_event.dart';

class KnownEventInputModel {
  final int eid;
  final String instant;
  final bool? won;
  final int? islandId;

  KnownEventInputModel.fromJson(Map<String, dynamic> json):
      eid = json["eid"],
      instant = json["instant"],
      won = json["won"],
      islandId = json["islandId"];
}

extension ToDomain on KnownEventInputModel {
  KnownEvent toKnownEvent() {
    final wonCast = won;
    final islandIdCast = islandId;
    if (wonCast != null) {
      return FightEvent(
          eid: eid,
          instant: DateTime.parse(instant),
          won: wonCast
      );
    } else if (islandIdCast != null) {
      return IslandEvent(
          eid: eid,
          instant: DateTime.parse(instant),
          islandId: islandIdCast
      );
    }

    throw Exception("Invalid Input Model");
  }
}