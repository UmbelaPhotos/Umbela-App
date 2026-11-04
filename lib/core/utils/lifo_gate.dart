import 'dart:async';

/// Runs at most [limit] tasks at once. Waiting tasks start newest first: the
/// cells nearest to the viewport are the ones requested last while scrolling.
class LifoGate {
  LifoGate(this.limit);

  final int limit;
  int _running = 0;
  final _waiting = <Completer<void>>[];

  Future<T> run<T>(Future<T> Function() task) async {
    if (_running >= limit) {
      final turn = Completer<void>();
      _waiting.add(turn);
      await turn.future;
    } else {
      _running++;
    }
    try {
      return await task();
    } finally {
      if (_waiting.isEmpty) {
        _running--;
      } else {
        // Hand the slot straight to the newest waiter.
        _waiting.removeLast().complete();
      }
    }
  }
}
