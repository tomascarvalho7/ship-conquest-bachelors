import 'package:ship_conquest/domain/immutable_collections/grid.dart';
import 'package:ship_conquest/services/input_models/coord_2d_input_model.dart';

import '../../../domain/ship/ship.dart';
import '../../../domain/ship/utils/classes/ship_path.dart';
import '../../../domain/utils/build_bezier.dart';
import '../event/known_event_input_model.dart';
import '../event/unknown_event_input_model.dart';
import '../utils/decode.dart';
import 'movement_input_model.dart';

class ShipInputModel {
  final int sid;
  final MovementInputModel movement;
  final List<KnownEventInputModel> completedEvents;
  final List<UnknownEventInputModel> futureEvents;

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

extension ToDomain on ShipInputModel {
  Ship toShip() {
    final startTime = movement.startTime;
    final duration = movement.duration;
    final landmarks = movement.landmarks;
    final coord = movement.coord;
    final completed =  Grid(data: { for(var event in completedEvents) event.eid : event.toKnownEvent() });
    final future = Grid(data: { for(var event in futureEvents) event.eid : event.toUnknownEvent() });

    if (startTime != null && duration != null && landmarks != null) {
      return MobileShip(
          sid: sid,
          path: ShipPath(
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
    throw Exception("Invalid input model");
  }
}

