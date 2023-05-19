import 'package:ship_conquest/services/input_models/event/unknown_event_input_model.dart';

import '../../../domain/event/unknown_event.dart';

class EventNotificationInputModel {
  final int sid;
  final UnknownEventInputModel event;

  EventNotificationInputModel.fromJson(Map<String, dynamic> json) :
      sid = json['sid'],
      event = json['event'];
}

extension ToDomain on EventNotificationInputModel {
  (int sid, UnknownEvent event) toDomain() =>
    (sid, event.toUnknownEvent());
}