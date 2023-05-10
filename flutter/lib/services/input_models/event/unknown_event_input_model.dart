import '../../../domain/event/unknown_event.dart';

class UnknownEventInputModel {
  final String info;
  final int eid;
  final String instant;

  UnknownEventInputModel.fromJson(Map<String, dynamic> json):
      info = json["info"],
      eid = json["eid"],
      instant = json["instant"];
}

extension ToDomain on UnknownEventInputModel {
  UnknownEvent toUnknownEvent() =>
      UnknownEvent(
          eid: eid,
          instant: DateTime.parse(instant)
      );
}