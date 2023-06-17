
import 'package:ship_conquest/domain/event/unknown_event.dart';
import 'package:ship_conquest/services/input_models/utils/decode.dart';

/// Input model class representing input data for a known event.
class UnknownEventInputModel {
  final String info;
  final int eid;
  final String duration;

  // Constructor to deserialize the input model from a JSON map.
  UnknownEventInputModel.fromJson(Map<String, dynamic> json):
      info = json["info"],
      eid = json["eid"],
      duration = json["duration"];
}

// An extension on the [UnknownEventInputModel] class to convert it to an [UnknownEvent] domain object.
extension ToDomain on UnknownEventInputModel {
  /// Converts the [UnknownEventInputModel] to a [UnknownEvent] object.
  UnknownEvent toUnknownEvent() =>
      UnknownEvent(
          eid: eid,
          duration: parseDuration(duration)
      );
}