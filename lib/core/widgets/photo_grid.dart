import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../data/models.dart';
import 'photo_thumb.dart';

const monthNames = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', //
  'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
];

/// Space between cells, and the layout math shared with the timeline list,
/// which must know every row's height before building it.
const masonryGap = 6.0;

/// Target row height: a third of the grid, like the old square cells.
double masonryCellWidth(double width) => (width - masonryGap * 2) / 3;

class PhotoGroup {
  PhotoGroup(this.label, this.photos);
  final String label;
  final List<Photo> photos;
}

/// Buckets photos into Hoy / Ayer / Este mes / "Mes año", newest first.
List<PhotoGroup> groupPhotos(List<Photo> photos, {DateTime? now}) {
  now ??= DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final sorted = [...photos]..sort((a, b) => b.takenAt.compareTo(a.takenAt));
  final groups = <String, PhotoGroup>{};
  for (final p in sorted) {
    final day = DateTime(p.takenAt.year, p.takenAt.month, p.takenAt.day);
    final diff = today.difference(day).inDays;
    final String label;
    if (diff == 0) {
      label = 'Hoy';
    } else if (diff == 1) {
      label = 'Ayer';
    } else if (day.year == today.year && day.month == today.month) {
      label = 'Este mes';
    } else {
      label = '${monthNames[day.month - 1]} ${day.year}';
    }
    groups.putIfAbsent(label, () => PhotoGroup(label, [])).photos.add(p);
  }
  return groups.values.toList();
}

/// One row of the justified grid: every photo has the row's [height] and a
/// width that follows its aspect ratio.
class JustifiedRow {
  JustifiedRow(this.photos, this.height, this.widths);
  final List<Photo> photos;
  final double height;
  final List<double> widths;
}

/// Rows a chunk is cut into; each chunk is built lazily on its own.
const _rowsPerChunk = 8;

double _rowHeight(double aspects, int n, double width) =>
    (width - masonryGap * (n - 1) - 0.01) / aspects;

JustifiedRow _row(List<Photo> photos, double height) => JustifiedRow(
  photos,
  height,
  [for (final p in photos) p.layoutAspect * height],
);

/// Google Photos style layout: photos keep their proportions and are packed
/// into rows of equal height that fill [width]. The last row is left short
/// instead of being stretched.
List<JustifiedRow> justifiedRows(List<Photo> photos, double width) {
  final target = masonryCellWidth(width);
  final rows = <JustifiedRow>[];
  var cur = <Photo>[];
  var sum = 0.0;
  for (final p in photos) {
    cur.add(p);
    sum += p.layoutAspect;
    if (sum * target + masonryGap * (cur.length - 1) < width) continue;
    var h = _rowHeight(sum, cur.length, width);
    if (cur.length > 1) {
      // Leave the last photo for the next row when that gets this row
      // closer to the target height.
      final without = sum - p.layoutAspect;
      final hWithout = _rowHeight(without, cur.length - 1, width);
      if (hWithout / target < target / h) {
        rows.add(_row(cur.sublist(0, cur.length - 1), hWithout));
        cur = [p];
        sum = p.layoutAspect;
        continue;
      }
    }
    rows.add(_row(cur, h));
    cur = [];
    sum = 0;
  }
  if (cur.isNotEmpty) {
    final h = math.min(_rowHeight(sum, cur.length, width), target * 1.3);
    rows.add(_row(cur, math.min(h, target * 1.3)));
  }
  return rows;
}

List<List<JustifiedRow>> chunkRows(List<JustifiedRow> rows) => [
  for (var i = 0; i < rows.length; i += _rowsPerChunk)
    rows.sublist(i, math.min(i + _rowsPerChunk, rows.length)),
];

/// Height a chunk takes, bottom gap of every row included.
double chunkExtent(List<JustifiedRow> chunk) =>
    chunk.fold(0.0, (h, r) => h + r.height + masonryGap);

class JustifiedGrid extends StatelessWidget {
  const JustifiedGrid({super.key, required this.rows, required this.onTap});

  final List<JustifiedRow> rows;
  final void Function(Photo) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final r in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: masonryGap),
            child: SizedBox(
              height: r.height,
              child: Row(
                children: [
                  for (var i = 0; i < r.photos.length; i++) ...[
                    if (i > 0) const SizedBox(width: masonryGap),
                    SizedBox(
                      width: r.widths[i],
                      height: r.height,
                      child: GestureDetector(
                        key: ValueKey('photo-${r.photos[i].id}'),
                        onTap: () => onTap(r.photos[i]),
                        child: PhotoThumb(r.photos[i]),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Date-grouped masonry, as slivers so it can sit inside any scroll view.
List<Widget> timelineSlivers(
  List<Photo> photos,
  void Function(Photo) onTap, {
  TextStyle? headerStyle,
}) {
  return [
    for (final g in groupPhotos(photos)) ...[
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
        sliver: SliverToBoxAdapter(
          child: Text(
            g.label,
            style:
                headerStyle ??
                const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: _lazyGrid(g.photos, onTap),
      ),
    ],
  ];
}

Widget _lazyGrid(List<Photo> photos, void Function(Photo) onTap) {
  return SliverLayoutBuilder(
    builder: (_, c) {
      final chunks = chunkRows(justifiedRows(photos, c.crossAxisExtent));
      return SliverList.builder(
        itemCount: chunks.length,
        itemBuilder: (_, i) => JustifiedGrid(rows: chunks[i], onTap: onTap),
      );
    },
  );
}
