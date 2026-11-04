import 'dart:math' as math;

import '../../../core/data/models.dart';
import '../../../core/timeline/timeline_controller.dart';
import '../../../core/widgets/photo_grid.dart';

const timelineSideInset = 16.0;
const timelineHeaderHeight = 40.0;

enum EntryKind { header, chunk, placeholder }

/// One row of the flat timeline list. Its height is known without building
/// it, which is what makes jumping to any month exact and the scroll bar
/// honest even though most months are not loaded.
class TimelineEntry {
  const TimelineEntry.header(this.monthKey, this.label)
    : kind = EntryKind.header,
      extent = timelineHeaderHeight,
      rows = const [],
      count = 0;

  const TimelineEntry.chunk(this.monthKey, this.rows, this.extent)
    : kind = EntryKind.chunk,
      label = '',
      count = 0;

  const TimelineEntry.placeholder(this.monthKey, this.count, this.extent)
    : kind = EntryKind.placeholder,
      label = '',
      rows = const [];

  final EntryKind kind;
  final int monthKey;
  final double extent;
  final String label;
  final List<JustifiedRow> rows;

  /// Photos a placeholder stands for.
  final int count;
}

String monthTitle(TimelineBucket b, DateTime now) =>
    b.year == now.year && b.month == now.month
    ? 'Este mes'
    : '${monthNames[b.month - 1]} ${b.year}';

/// Height of a skeleton for [count] photos not loaded yet.
double placeholderExtent(int count, double unitsPerPhoto, double width) {
  final row = masonryCellWidth(width) + masonryGap;
  return math.max(1, (count * unitsPerPhoto / 3).ceil()) * row;
}

List<TimelineEntry> monthEntries(
  TimelineBucket bucket,
  MonthData data,
  double width,
  double unitsPerPhoto,
  DateTime now,
) {
  final photos = data.photos;
  final out = <TimelineEntry>[];
  if (photos.isEmpty) {
    out.add(TimelineEntry.header(bucket.key, monthTitle(bucket, now)));
  } else {
    for (final g in groupPhotos(photos, now: now)) {
      out.add(TimelineEntry.header(bucket.key, g.label));
      for (final chunk in chunkRows(justifiedRows(g.photos, width))) {
        out.add(TimelineEntry.chunk(bucket.key, chunk, chunkExtent(chunk)));
      }
    }
  }
  final missing = bucket.count - photos.length;
  if (missing > 0) {
    out.add(
      TimelineEntry.placeholder(
        bucket.key,
        missing,
        placeholderExtent(missing, unitsPerPhoto, width),
      ),
    );
  }
  return out;
}

class _CachedMonth {
  _CachedMonth(this.data, this.count, this.width, this.units, this.entries);
  final MonthData data;
  final int count;
  final double width;
  final double units;
  final List<TimelineEntry> entries;
}

/// Flat list of every month's entries with their offsets.
class TimelineLayout {
  TimelineLayout._(this.entries, this.offsets, this.total, this._firstOf);

  final List<TimelineEntry> entries;

  /// offsets[i] = scroll offset where entry i starts.
  final List<double> offsets;
  final double total;
  final Map<int, int> _firstOf;

  /// Scroll offset of the first entry of a month.
  double? offsetOfMonth(int monthKey) {
    final i = _firstOf[monthKey];
    return i == null ? null : offsets[i];
  }

  int indexAt(double offset) {
    if (entries.isEmpty) return 0;
    var lo = 0, hi = entries.length - 1;
    while (lo < hi) {
      final mid = (lo + hi + 1) >> 1;
      if (offsets[mid] <= offset) {
        lo = mid;
      } else {
        hi = mid - 1;
      }
    }
    return lo;
  }

  int? monthKeyAt(double offset) =>
      entries.isEmpty ? null : entries[indexAt(offset)].monthKey;

  /// Builds the layout, reusing the entries of months that did not change.
  /// [cache] belongs to the caller and must be kept between calls.
  static TimelineLayout build(
    TimelineState state,
    double width,
    Map<int, Object> cache, {
    DateTime? now,
  }) {
    now ??= DateTime.now();
    final units = state.unitsPerPhoto;
    final entries = <TimelineEntry>[];
    final first = <int, int>{};
    for (final b in state.buckets) {
      final data = state.month(b.key);
      final hit = cache[b.key] as _CachedMonth?;
      // Only skeletons depend on the average; loaded rows do not.
      final unitsMatter = data.photos.length < b.count;
      final List<TimelineEntry> list;
      if (hit != null &&
          identical(hit.data, data) &&
          hit.count == b.count &&
          hit.width == width &&
          (!unitsMatter || hit.units == units)) {
        list = hit.entries;
      } else {
        list = monthEntries(b, data, width, units, now);
        cache[b.key] = _CachedMonth(data, b.count, width, units, list);
      }
      first[b.key] = entries.length;
      entries.addAll(list);
    }
    final offsets = List<double>.filled(entries.length, 0);
    var y = 0.0;
    for (var i = 0; i < entries.length; i++) {
      offsets[i] = y;
      y += entries[i].extent;
    }
    return TimelineLayout._(entries, offsets, y, first);
  }
}
