/// Which thumbnails does the screen want right now, and how urgently?
///
/// Grid cells register while they are mounted with a callback that says where
/// they are on screen. The thumbnail queue asks here when it picks its next
/// request, so the cell nearest the top of the screen goes first and a cell
/// that scrolled away is not fetched at all (it waits, queued, until it comes
/// back).
class ThumbInterest {
  final _cells = <String, List<double? Function()>>{};
  final _gone = <String>{};
  final _listeners = <void Function()>[];

  /// Called when something that was not eligible may be now.
  void addListener(void Function() l) => _listeners.add(l);

  void register(String id, double? Function() priority) {
    (_cells[id] ??= []).add(priority);
    _gone.remove(id);
    _notify();
  }

  void unregister(String id, double? Function() priority) {
    final list = _cells[id];
    if (list == null) return;
    list.remove(priority);
    if (list.isEmpty) {
      _cells.remove(id);
      _gone.add(id);
    }
  }

  final _pinned = <String, DateTime>{};
  static const _pinFor = Duration(seconds: 30);

  /// Someone other than a grid cell (avatar, viewer) wants [id] now, even if
  /// the cell that shows it is covered or gone. Cheap to call on every build.
  void pin(String id) {
    final fresh = !_pinned.containsKey(id);
    _pinned[id] = DateTime.now();
    if (_gone.remove(id) || fresh) _notify();
  }

  /// The screen showing the cells became active again.
  void wake() => _notify();

  /// Lower is more urgent; null means nobody on screen wants it.
  double? priorityOf(String id) {
    final pinnedAt = _pinned[id];
    if (pinnedAt != null) {
      if (DateTime.now().difference(pinnedAt) < _pinFor) return -1;
      _pinned.remove(id);
    }
    final list = _cells[id];
    if (list == null) return _gone.contains(id) ? null : -1;
    double? best;
    for (final f in list) {
      final p = f();
      if (p != null && (best == null || p < best)) best = p;
    }
    return best;
  }

  void _notify() {
    for (final l in _listeners) {
      l();
    }
  }
}

final thumbInterest = ThumbInterest();
