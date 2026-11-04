import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models.dart';
import '../providers.dart';
import '../storage/timeline_cache.dart';
import '../utils/lifo_gate.dart';

/// What is known about one month's photos.
class MonthData {
  const MonthData({
    this.photos = const [],
    this.loading = false,
    this.stale = false,
    this.error,
  });

  /// Newest first. May be a prefix of the month (cache, or a load in flight).
  final List<Photo> photos;
  final bool loading;

  /// Loaded before, but the server may have changed it: reload when seen.
  final bool stale;
  final Object? error;

  MonthData copyWith({List<Photo>? photos, bool? loading, Object? error}) =>
      MonthData(
        photos: photos ?? this.photos,
        loading: loading ?? this.loading,
        stale: stale,
        error: error ?? this.error,
      );
}

class TimelineState {
  TimelineState({
    this.buckets = const [],
    this.months = const {},
    this.connecting = false,
    this.error,
  });

  /// Every month of the library, newest first. Always complete.
  final List<TimelineBucket> buckets;
  final Map<int, MonthData> months;

  /// No session yet (Tor still starting) and nothing cached to show.
  final bool connecting;

  /// Last failed refresh. What is on screen stays.
  final Object? error;

  late final Map<int, TimelineBucket> bucketByKey = {
    for (final b in buckets) b.key: b,
  };

  MonthData month(int key) => months[key] ?? const MonthData();

  bool needsLoad(TimelineBucket b) {
    final m = month(b.key);
    return m.stale || m.photos.length != b.count;
  }

  int get totalPhotos => buckets.fold(0, (n, b) => n + b.count);

  /// Photos loaded so far, newest first (search, viewer lookups).
  Iterable<Photo> get loadedPhotos sync* {
    for (final b in buckets) {
      yield* month(b.key).photos;
    }
  }

  List<Photo> get allPhotos => loadedPhotos.toList();

  /// Square cells a photo takes on average (its aspect ratio: a wide photo
  /// is wider than a cell); used to size months that are not loaded yet.
  late final double unitsPerPhoto = () {
    var photos = 0;
    var units = 0.0;
    for (final m in months.values) {
      for (final p in m.photos) {
        photos++;
        units += p.layoutAspect;
      }
    }
    return photos < 30 ? 1.25 : units / photos;
  }();

  TimelineState copyWith({
    List<TimelineBucket>? buckets,
    Map<int, MonthData>? months,
    bool? connecting,
    Object? error,
    bool clearError = false,
  }) => TimelineState(
    buckets: buckets ?? this.buckets,
    months: months ?? this.months,
    connecting: connecting ?? this.connecting,
    error: clearError ? null : error ?? this.error,
  );
}

/// The timeline as a list of months. The month list (counts only) comes first
/// and is cached, so the whole library can be laid out and scrubbed through at
/// once; a month's photos (blurhashes) are fetched only when that month has
/// been on screen for a moment, so flinging through years requests nothing.
class TimelineController extends AsyncNotifier<TimelineState> {
  /// How long the visible months must stay put before they are fetched.
  static const settle = Duration(milliseconds: 180);
  static const _pageSize = 500;

  final _visible = <int, int>{};
  final _retry = <int>{};
  final _gate = LifoGate(2);
  Timer? _debounce;
  Future<void> _lastWrite = Future.value();
  bool _refreshing = false;

  @override
  Future<TimelineState> build() async {
    final token = ref.watch(sessionTokenProvider);
    ref.onDispose(() => _debounce?.cancel());

    final cached = await ref.read(timelineCacheProvider).read();
    final fromCache = _fromCache(cached, connecting: token == null);
    if (token == null) return fromCache;
    if (cached.buckets.isNotEmpty) {
      // Event queue, not microtask: must run after this build's state lands.
      Future(refresh);
      return fromCache;
    }
    final buckets = await ref.read(photoRepositoryProvider).timelineBuckets();
    _persist(buckets, const []);
    return TimelineState(buckets: buckets);
  }

  TimelineState _fromCache(CachedTimeline c, {required bool connecting}) {
    final byMonth = <int, List<Photo>>{};
    for (final p in c.photos) {
      for (final b in c.buckets) {
        if (b.contains(p.takenAt)) {
          (byMonth[b.key] ??= []).add(p);
          break;
        }
      }
    }
    return TimelineState(
      buckets: c.buckets,
      months: {
        for (final e in byMonth.entries) e.key: MonthData(photos: e.value),
      },
      connecting: connecting && c.buckets.isEmpty,
    );
  }

  /// Pull-to-refresh and the retry after a failure. Fetches the month list
  /// again; months whose count changed (and the newest) reload when seen.
  Future<void> refresh() async {
    if (!ref.mounted || _refreshing) return;
    if (ref.read(sessionTokenProvider) == null) return;
    _refreshing = true;
    final current = state.value ?? TimelineState();
    try {
      final buckets = await ref.read(photoRepositoryProvider).timelineBuckets();
      if (!ref.mounted) return;
      final before = current.bucketByKey;
      final months = <int, MonthData>{};
      for (final b in buckets) {
        final m = current.months[b.key];
        if (m == null) continue;
        final changed =
            before[b.key]?.count != b.count || b.key == buckets.first.key;
        months[b.key] = MonthData(
          photos: m.photos,
          loading: m.loading,
          stale: m.stale || changed,
        );
      }
      state = AsyncData(TimelineState(buckets: buckets, months: months));
      _persist(buckets, _newestLoaded(buckets, months));
      _scheduleLoad(immediately: true);
    } catch (e, st) {
      if (!ref.mounted) return;
      state = current.buckets.isEmpty
          ? AsyncError(e, st)
          : AsyncData(current.copyWith(error: e));
    } finally {
      _refreshing = false;
    }
  }

  /// A widget showing (a piece of) [monthKey] appeared (+1) or went away (-1).
  void track(int monthKey, int delta) {
    final n = (_visible[monthKey] ?? 0) + delta;
    if (n <= 0) {
      _visible.remove(monthKey);
      return;
    }
    _visible[monthKey] = n;
    if (delta > 0) {
      final s = state.value;
      final bucket = s?.bucketByKey[monthKey];
      // A month that is already complete has nothing to fetch.
      if (s != null && bucket != null && !s.needsLoad(bucket)) return;
      // Coming back to a month that failed earns it one more try.
      _retry.add(monthKey);
      _scheduleLoad();
    }
  }

  void _scheduleLoad({bool immediately = false}) {
    _debounce?.cancel();
    if (immediately) return _loadVisible();
    _debounce = Timer(settle, _loadVisible);
  }

  void _loadVisible() {
    final s = state.value;
    if (s == null || !ref.mounted) return;
    if (ref.read(sessionTokenProvider) == null) return;
    for (final key in _visible.keys.toList()) {
      final b = s.bucketByKey[key];
      if (b == null) continue;
      final m = s.month(key);
      if (m.loading || !s.needsLoad(b)) continue;
      if (m.error != null && !_retry.contains(key)) continue;
      _patch(key, (m) => m.copyWith(loading: true));
      unawaited(_gate.run(() => _fetchMonth(key)));
    }
    _retry.clear();
  }

  Future<void> _fetchMonth(int key) async {
    final s = state.value;
    final bucket = s?.bucketByKey[key];
    if (s == null || bucket == null || !ref.mounted) return;
    // Scrolled away while waiting for a slot: do not spend Tor on it.
    if (!_visible.containsKey(key)) {
      _patch(key, (m) => m.copyWith(loading: false));
      return;
    }
    final repo = ref.read(photoRepositoryProvider);
    final showProgress = s.month(key).photos.isEmpty;
    final fresh = <Photo>[];
    var cursor = '';
    try {
      do {
        final page = await repo.timelinePage(
          from: bucket.from,
          to: bucket.to,
          cursor: cursor,
          pageSize: _pageSize,
        );
        if (!ref.mounted) return;
        fresh.addAll(page.photos);
        cursor = page.photos.isEmpty ? '' : page.nextCursor;
        if (showProgress && cursor.isNotEmpty) {
          _patch(key, (m) => m.copyWith(photos: List.of(fresh)));
        }
      } while (cursor.isNotEmpty);
      _patch(key, (_) => MonthData(photos: fresh));
      final now = state.value;
      if (now != null) {
        _persist(
          now.buckets,
          _newestLoaded(now.buckets, now.months),
          touched: key,
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      _patch(key, (m) => m.copyWith(loading: false, error: e));
    }
  }

  void _patch(int key, MonthData Function(MonthData) change) {
    final s = state.value;
    if (s == null || !ref.mounted) return;
    state = AsyncData(
      s.copyWith(months: {...s.months, key: change(s.month(key))}),
    );
  }

  List<Photo> _newestLoaded(
    List<TimelineBucket> buckets,
    Map<int, MonthData> months,
  ) {
    final out = <Photo>[];
    for (final b in buckets) {
      out.addAll(months[b.key]?.photos ?? const []);
      if (out.length >= TimelineCache.maxPhotos) break;
    }
    return out;
  }

  /// Writes the cache. A month deep in the past ([touched]) is not in it, so
  /// loading one does not rewrite anything.
  void _persist(
    List<TimelineBucket> buckets,
    List<Photo> photos, {
    int? touched,
  }) {
    if (touched != null) {
      var before = 0;
      for (final b in buckets) {
        if (b.key == touched) break;
        before += b.count;
      }
      if (before >= TimelineCache.maxPhotos) return;
    }
    final cache = ref.read(timelineCacheProvider);
    _lastWrite = _lastWrite.then((_) => cache.write(buckets, photos));
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineController, TimelineState>(
      TimelineController.new,
    );

/// What we know about a photo before its details arrive: the timeline entry
/// (blurhash, aspect), else whatever the details call returned.
final photoMetaProvider = Provider.family<Photo?, String>((ref, id) {
  final timeline = ref.watch(timelineProvider).value;
  if (timeline != null) {
    for (final p in timeline.loadedPhotos) {
      if (p.id == id) return p;
    }
  }
  return ref.watch(photoDetailsProvider(id)).value?.photo;
});
