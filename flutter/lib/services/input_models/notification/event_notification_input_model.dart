import 'package:ship_conquest/domain/event/unknown_event.dart';
import 'package:ship_conquest/services/input_models/event/unknown_event_input_model.dart';

/// Input model class representing input data for an event notification.
class EventNotificationInputModel {
  final int sid;
  final UnknownEventInputModel event;

  // Constructor to deserialize the input model from a JSON map.
  EventNotificationInputModel.fromJson(Map<String, dynamic> json) :
        sid = json['sid'],
        event = UnknownEventInputModel.fromJson(json['event']);
}

// An extension on the [EventNotificationInputModel] class to convert it to a domain
// object containing an [integer] representing the ship's id and an [UnknownEvent] domain object.
extension ToDomain on EventNotificationInputModel {
  /// Converts the [EventNotificationInputModel] to a domain object containing an
  /// [integer] representing the ship's id and an [UnknownEvent] domain object.
  (int sid, UnknownEvent event) toDomain() =>
    (sid, event.toUnknownEvent());
}