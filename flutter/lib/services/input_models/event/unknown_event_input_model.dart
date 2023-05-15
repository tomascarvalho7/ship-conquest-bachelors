import '../../../domain/event/unknown_event.dart';
import '../utils/decode.dart';

class UnknownEventInputModel {
  final String info;
  final int eid;
  final String duration;

  UnknownEventInputModel.fromJson(Map<String, dynamic> json):
      info = json["info"],
      eid = json["eid"],
      duration = json["duration"];
}

extension ToDomain on UnknownEventInputModel {
  UnknownEvent toUnknownEvent() =>
      UnknownEvent(
          eid: eid,
          duration: parseDuration(duration)
      );
}