import 'dart:async';

/// Runs at most [limit] tasks at once. Waiting tasks start in priority order
/// (lowest number first), and the priority is read when a slot frees up, not
/// when the task was queued, so it reflects what is on screen right now.
///
/// A task whose priority callback returns null is not eligible: it stays
/// queued, without using a slot, until it becomes eligible again and the gate
/// is nudged with [pump].
class PriorityGate {
  PriorityGate(this.limit, {this.coalesce = const Duration(milliseconds: 20)});

  final int limit;

  /// Queuing waits this long before picking, so a screenful of cells that all
  /// asked in the same instant is ordered as a whole instead of first-come.
  final Duration coalesce;

  int _running = 0;
  final _waiting = <_Waiter>[];
  Timer? _timer;

  Future<T> run<T>(
    Future<T> Function() task, {
    double? Function()? priority,
  }) async {
    final waiter = _Waiter(priority);
    _waiting.add(waiter);
    _schedule();
    await waiter.turn.future;
    try {
      return await task();
    } finally {
      _running--;
      pump();
    }
  }

  void _schedule() {
    _timer ??= Timer(coalesce, () {
      _timer = null;
      pump();
    });
  }

  /// Like [pump], but later: for callers that may be mid-build.
  void nudge() => _schedule();

  /// Starts waiting tasks while there are free slots, best priority first.
  void pump() {
    while (_running < limit && _waiting.isNotEmpty) {
      var best = -1;
      var bestPriority = double.infinity;
      for (var i = 0; i < _waiting.length; i++) {
        final p = _waiting[i].priorityNow();
        if (p != null && p < bestPriority) {
          best = i;
          bestPriority = p;
        }
      }
      if (best < 0) return;
      _running++;
      _waiting.removeAt(best).turn.complete();
    }
  }
}

class _Waiter {
  _Waiter(this._priority);

  final double? Function()? _priority;
  final turn = Completer<void>();

  double? priorityNow() {
    final f = _priority;
    if (f == null) return 0;
    try {
      return f();
    } catch (_) {
      return 1e9;
    }
  }
}
