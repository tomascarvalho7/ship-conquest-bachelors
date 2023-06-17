import 'package:ship_conquest/domain/immutable_collections/grid.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/domain/ship/utils/classes/ship_path.dart';
import 'package:ship_conquest/domain/utils/build_bezier.dart';
import 'package:ship_conquest/services/input_models/space/coord_2d_input_model.dart';
import 'package:ship_conquest/services/input_models/event/known_event_input_model.dart';
import 'package:ship_conquest/services/input_models/event/unknown_event_input_model.dart';
import 'package:ship_conquest/services/input_models/ship/movement_input_model.dart';
import 'package:ship_conquest/services/input_models/utils/decode.dart';


/// Input model class representing input data for ship with all its properties.
///
/// - [sid] the ship's identifier
/// - [movement] the ship's current position or movement
/// - [completedEvents] the ship's completed events
/// - [futureEvents] the events the ship has not yet been through
class ShipInputModel {
  final int sid;
  final MovementInputModel movement;
  final List<KnownEventInputModel> completedEvents;
  final List<UnknownEventInputModel> futureEvents;

  // Constructor to deserialize the input model from a JSON map.
  ShipInputModel.fromJson(Map<String, dynamic> json):
      sid = json["sid"],
      movement = MovementInputModel.fromJson(json["movement"]),
      completedEvents = List<dynamic>.from(json['completedEvents'])
          .map((e) => KnownEventInputModel.fromJson(e))
          .toList(),
      futureEvents = List<dynamic>.from(json['futureEvents'])
          .map((e) => UnknownEventInputModel.fromJson(e))
          .toList();
}

// An extension on the [ShipInputModel] class to convert it to an [Ship] domain object.
extension ToDomain on ShipInputModel {
  /// Converts the [ShipInputModel] to a [Ship] object.
  Ship toShip() {
    // getting the properties to later assure non nullability
    final startTime = movement.startTime;
    final duration = movement.duration;
    final landmarks = movement.landmarks;
    final coord = movement.coord;
    final completed =  Grid(data: { for(var event in completedEvents) event.eid : event.toKnownEvent() });
    final future = Grid(data: { for(var event in futureEvents) event.eid : event.toUnknownEvent() });

    // if the start time, duration and landmarks exist, the ship is moving
    // else it's static
    if (startTime != null && duration != null && landmarks != null) {
      return MobileShip(
          sid: sid,
          path: ShipPath(
              // builds the Bézier curves from the list of 2D points
              landmarks: buildBeziers(landmarks.toCoord2DList()),
              startTime: DateTime.parse(startTime),
              duration: parseDuration(duration)
          ),
          completedEvents: completed,
          futureEvents: future
      );
    } else if (coord != null) {
      return StaticShip(
          sid: sid,
          coordinate: coord.toCoord2D(),
          completedEvents: completed,
          futureEvents: future
      );
    }
    // if the input model does not follow this conditions, its invalid
    throw Exception("Invalid input model");
  }
}

