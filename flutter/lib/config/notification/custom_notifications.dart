import 'package:ship_conquest/config/notification/notification_service.dart';
import 'package:ship_conquest/domain/ship/ship.dart';

import '../../domain/event/unknown_event.dart';

/// Schedules a phone notification to happen at an event's instant.
/// The content of the notification is vague and only states something happened
/// because future events are unknown.
/// The instant is calculating by adding the time missing to the event to the
/// current time.
void buildEventNotification(UnknownEvent event) async {
  NotificationService.scheduleNotification(
    event.eid,
    "Something Happened!",
    "Something happened to your ship. Come back to find out what happened.",
    DateTime.now().add(event.duration)
  );
}

/// Schedules a phone notification to happen when a ship has ended its path.
/// The notification instant is calculated by adding the route duration
/// to the starting time and the content is specific to the event.
void buildShipNotification(MobileShip ship) {
  NotificationService.scheduleNotification(
      ship.sid,
      "Ship Has Reached It's Destiny!",
      "Your ship has reached it's destiny. Come back to find out what happened.",
      ship.path.startTime.add(ship.path.duration)
  );
}