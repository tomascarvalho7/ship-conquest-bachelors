import 'package:ship_conquest/config/notification/notification_service.dart';
import 'package:ship_conquest/domain/ship/ship.dart';

import '../../domain/event/unknown_event.dart';

void buildEventNotification(UnknownEvent event) async {
  NotificationService.scheduleNotification(
    event.eid,
    "Something Happened!",
    "Something happened to your ship. Come back to find out what happened.",
    DateTime.now().add(event.duration)
  );
}

void buildShipNotification(MobileShip ship) {
  NotificationService.scheduleNotification(
      ship.sid,
      "Ship Has Reached It's Destiny!",
      "Your ship has reached it's destiny. Come back to find out what happened.",
      ship.path.startTime.add(ship.path.duration)
  );
}