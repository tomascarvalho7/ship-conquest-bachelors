import 'package:flutter_test/flutter_test.dart';
import 'package:ship_conquest/domain/event/known_event.dart';
import 'package:ship_conquest/domain/event/unknown_event.dart';
import 'package:ship_conquest/domain/island/island.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';

void main() {
  group('FightEvent', () {
    test('should have the correct properties', () {
      final event = FightEvent(eid: 1, instant: DateTime.now(), won: true);

      expect(event.eid, 1);
      expect(event.instant, isA<DateTime>());
      expect(event.won, true);
    });
  });

  group('IslandEvent', () {
    test('should have the correct properties', () {
      final island = WildIsland(id: 1, coordinate: Coord2D(x: 10, y: 10), radius: 20);
      final event = IslandEvent(eid: 1, instant: DateTime.now(), island: island);

      expect(event.eid, 1);
      expect(event.instant, isA<DateTime>());
      expect(event.island, island);
    });
  });

  group('UnknownEvent', () {
    test('should have the correct properties', () {
      final event = UnknownEvent(eid: 1, duration: const Duration(seconds: 10));

      expect(event.eid, 1);
      expect(event.duration, const Duration(seconds: 10));
    });
  });
}