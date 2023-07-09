import 'dart:async';

import 'package:ship_conquest/domain/immutable_collections/grid.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/immutable_collections/utils/extend_grid.dart';


///
/// Independent game related controller that holds [State] of
/// the scheduled [Tasks].
///
/// The [ScheduleController] manages the scheduled tasks. They can be either:
/// - A [Job] running periodically every X seconds.
/// - A [Event] running once on a programmed [Instant].
///
class ScheduleController {
  Sequence<Timer> _jobs = Sequence.empty();
  Grid<int, Timer> _scheduled = Grid.empty();

  /// Schedules a job which runs every [duration] and executes the [callback] function.
  void scheduleJob(Duration duration, Function callback) {
    final timer = Timer.periodic(duration, (timer) { callback(); });
    _jobs = _jobs.put(timer);
  }

  /// Schedules an event associated with [key] to run after passing [after]
  /// and executes the [callback] function.
  void scheduleEvent(int key, Duration after, Function callback) {
    final timer = Timer(after + const Duration(seconds: 1), ()  { callback(); cancelEvent(key); });
    _scheduled = _scheduled.put(key, timer);
  }

  /// Cancels the scheduled event with the key [key].
  void cancelEvent(int key) {
    _scheduled.getOrNull(key)?.cancel(); // cancel
    _scheduled = _scheduled.delete(key); // delete from tasks
  }

  /// Stops and clears all the scheduled jobs and events
  void stop() {
    for(var timer in _jobs.data) {
      timer.cancel();
    }
    for(var timer in _scheduled.toSequence().data) {
      timer.cancel();
    }
    _jobs = Sequence.empty();
    _scheduled = Grid.empty();
  }
}