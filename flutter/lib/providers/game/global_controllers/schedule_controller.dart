import 'dart:async';

import 'package:ship_conquest/domain/immutable_collections/sequence.dart';

import '../../../domain/immutable_collections/grid.dart';

class ScheduleController {
  Sequence<Timer> _jobs = Sequence.empty();
  Grid<int, Timer> _scheduled = Grid.empty();

  void scheduleJob(Duration duration, Function callback) {
    final timer = Timer.periodic(duration, (timer) { callback(); });
    _jobs = _jobs.put(timer);
  }

  void scheduleEvent(int key, Duration after, Function callback) {
    // check if event already exists
    if (_scheduled.getOrNull(key) != null) return;
    final timer = Timer(after, () => callback());
    _scheduled = _scheduled.put(key, timer);
  }

  void cancelEvent(int key) {
    _scheduled.getOrNull(key)?.cancel(); // cancel
    _scheduled = _scheduled.delete(key); // delete from tasks
  }

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