/// Ignores calls that arrive while a previous call is still running.
///
/// Guards async actions (check answer, go next) against double taps and
/// keyboard events that fire twice, which would otherwise run the action
/// twice and, for example, skip a question or count an attempt twice.
class RunOnce {
  bool _running = false;

  Future<void> call(Future<void> Function() action) async {
    if (_running) return;

    _running = true;
    try {
      await action();
    } finally {
      _running = false;
    }
  }
}
