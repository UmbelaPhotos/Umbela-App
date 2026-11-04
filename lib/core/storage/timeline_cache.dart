import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../data/models.dart';

class CachedTimeline {
  const CachedTimeline(this.buckets, this.photos);
  const CachedTimeline.empty() : buckets = const [], photos = const [];

  /// Every month, newest first.
  final List<TimelineBucket> buckets;

  /// Only the newest photos (see [TimelineCache.maxPhotos]).
  final List<Photo> photos;
}

/// What the timeline needs to paint before Tor is up: the month list (a few
/// KB, always complete) plus ids, dates and blurhashes of the newest photos.
/// Never image data. Kept in the Keychain/Keystore so it is encrypted at rest
/// like everything else on the phone.
///
/// The cap matters: the whole library's blurhashes would be megabytes, read
/// and decoded on every start. Older months are fetched when scrolled to.
class TimelineCache {
  TimelineCache([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const maxPhotos = 1000;
  static const _key = 'timeline_cache_v2';

  Future<CachedTimeline> read() async {
    try {
      final raw = await _storage.read(key: _key);
      if (raw == null) return const CachedTimeline.empty();
      final json = jsonDecode(raw) as Map<String, dynamic>;
      DateTime at(Object? unix) =>
          DateTime.fromMillisecondsSinceEpoch((unix as int) * 1000);
      return CachedTimeline(
        [
          for (final b in json['b'] as List)
            TimelineBucket(
              year: b[0] as int,
              month: b[1] as int,
              count: b[2] as int,
              from: at(b[3]),
              to: at(b[4]),
            ),
        ],
        [
          for (final e in json['p'] as List)
            Photo(
              id: e[0] as String,
              takenAt: at(e[1]),
              isVideo: e[2] == 1,
              blurhash: e[3] as String,
              aspect: (e[4] as num).toDouble(),
              tall: (e[4] as num) > 0 && (e[4] as num) < 1,
            ),
        ],
      );
    } catch (_) {
      return const CachedTimeline.empty();
    }
  }

  /// [photos] must be newest first; only the first [maxPhotos] are kept.
  Future<void> write(List<TimelineBucket> buckets, List<Photo> photos) async {
    int unix(DateTime t) => t.millisecondsSinceEpoch ~/ 1000;
    try {
      await _storage.write(
        key: _key,
        value: jsonEncode({
          'b': [
            for (final b in buckets)
              [b.year, b.month, b.count, unix(b.from), unix(b.to)],
          ],
          'p': [
            for (final p in photos.take(maxPhotos))
              [p.id, unix(p.takenAt), p.isVideo ? 1 : 0, p.blurhash, p.aspect],
          ],
        }),
      );
    } catch (_) {}
  }

  Future<void> clear() async {
    try {
      await _storage.delete(key: _key);
    } catch (_) {}
  }
}
