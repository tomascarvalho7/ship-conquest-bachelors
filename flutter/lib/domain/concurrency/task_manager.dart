class TaskManager<T> {
  bool _available = true;
  T? result;

  void tryToRunTask(Future<T> Function() task) async {
    if (!_available) return null; // if not available return null

    _available = false;
    // if available run and return task
    result = await task();
    _available = true;
  }
}