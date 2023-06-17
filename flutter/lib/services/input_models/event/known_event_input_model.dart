
import 'package:ship_conquest/domain/event/known_event.dart';
import 'package:ship_conquest/services/input_models/game/island_input_model.dart';


/// Input model class representing input data for a known event.
class KnownEventInputModel {
  final int eid;
  final String instant;
  final bool? won;
  final IslandInputModel? island;

  // Constructor to deserialize the input model from a JSON map.
  KnownEventInputModel.fromJson(Map<String, dynamic> json):
        eid = json["eid"],
        instant = json["instant"],
        won = json["won"],
        island = json['island'] != null ? IslandInputModel.fromJson(json['island']) : null;
}

// An extension on the [KnownEventInputModel] class to convert it to a [KnownEvent] domain object.
extension ToDomain on KnownEventInputModel {
  /// Converts the [KnownEventInputModel] to a [KnownEvent] object.
  KnownEvent toKnownEvent() {
    final wonCast = won;
    final islandCast = island;
    if (wonCast != null) {
      // If the 'won' property is not null, create a FightEvent object.
      return FightEvent(
          eid: eid,
          instant: DateTime.parse(instant),
          won: wonCast
      );
    } else if (islandCast != null) {
      // If the 'island' property is not null, create an IslandEvent object.
      return IslandEvent(
          eid: eid,
          instant: DateTime.parse(instant),
          island: islandCast.toIsland()
      );
    }

    // If neither 'won' nor 'island' properties are present, throw an exception indicating an invalid input model.
    throw Exception("Invalid Input Model");
  }
}
