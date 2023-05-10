import 'dart:async';

import '../../../domain/immutable_collections/sequence.dart';

class ScheduleController {
  Sequence<Timer> _timers = Sequence.empty();

  void schedule(Function callback, Duration duration) {
    print("schedule");
    final timer = Timer.periodic(duration, (timer) { callback(); });
    _timers = _timers.put(timer);
  }

  void run(Function callback, Duration after) {
    final timer = Timer(after, () => callback());
    _timers = _timers.put(timer);
  }

  void stop() {
    for(var timer in _timers.data) {
      timer.cancel();
    }
    _timers = Sequence.empty();
  }
}