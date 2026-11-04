import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/timeline/timeline_controller.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/photo_grid.dart';
import '../../../core/widgets/photo_thumb.dart';
import 'date_scrubber.dart';
import 'timeline_layout.dart';
import '../../viewer/presentation/photo_viewer_screen.dart';

/// The photo timeline: every month of the library in one scroll view, most of
/// them as skeletons until they have been on screen for a moment.
class TimelineView extends ConsumerStatefulWidget {
  const TimelineView({super.key, required this.state});

  final TimelineState state;

  @override
  ConsumerState<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends ConsumerState<TimelineView> {
  final _scroll = ScrollController();
  final _layoutCache = <int, Object>{};
  late final TimelineController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ref.read(timelineProvider.notifier);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  String _labelAt(TimelineLayout layout, double offset) {
    final key = layout.monthKeyAt(offset);
    final bucket = key == null ? null : widget.state.bucketByKey[key];
    return bucket == null ? '' : monthTitle(bucket, DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    if (state.buckets.isEmpty) {
      return PullRefresh(
        onRefresh: _controller.refresh,
        child: LayoutBuilder(
          builder: (context, c) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: c.maxHeight,
                child: Center(
                  child: state.connecting
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Aún no hay fotos',
                          style: TextStyle(color: AppColors.stem),
                        ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      children: [
        if (state.error != null) const _OfflineBanner(),
        Expanded(
          child: LayoutBuilder(
            builder: (context, c) {
              final width = c.maxWidth - timelineSideInset * 2;
              final layout = TimelineLayout.build(state, width, _layoutCache);
              final entries = layout.entries;
              return Stack(
                children: [
                  PullRefresh(
                    onRefresh: _controller.refresh,
                    child: CustomScrollView(
                      controller: _scroll,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverVariedExtentList(
                          itemExtentBuilder: (i, _) => entries[i].extent,
                          delegate: _ExactExtentDelegate(
                            (context, i) =>
                                _EntryView(entries[i], width: width),
                            childCount: entries.length,
                            total: layout.total,
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 110)),
                      ],
                    ),
                  ),
                  DateScrubber(
                    controller: _scroll,
                    labelAt: (offset) => _labelAt(layout, offset),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Flutter guesses the scroll length of a lazy list from the rows built so
/// far, which for thousands of months of unequal height is far off. We know
/// every row's height, so say the exact total: the scroll bar and the date
/// handle then map to the real position.
class _ExactExtentDelegate extends SliverChildBuilderDelegate {
  _ExactExtentDelegate(super.builder, {super.childCount, required this.total});

  final double total;

  @override
  double? estimateMaxScrollOffset(
    int firstIndex,
    int lastIndex,
    double leadingScrollOffset,
    double trailingScrollOffset,
  ) => total;
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
    child: Text(
      'Sin conexión con el servidor. Desliza hacia abajo para reintentar.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 12, color: AppColors.stem),
    ),
  );
}

/// Tells the controller which months are on screen so it can fetch them.
class _Track extends ConsumerStatefulWidget {
  const _Track({required this.monthKey, required this.child});

  final int monthKey;
  final Widget child;

  @override
  ConsumerState<_Track> createState() => _TrackState();
}

class _TrackState extends ConsumerState<_Track> {
  late final TimelineController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ref.read(timelineProvider.notifier);
    _controller.track(widget.monthKey, 1);
  }

  @override
  void dispose() {
    _controller.track(widget.monthKey, -1);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _EntryView extends StatelessWidget {
  const _EntryView(this.entry, {required this.width});

  final TimelineEntry entry;
  final double width;

  @override
  Widget build(BuildContext context) {
    final Widget child;
    switch (entry.kind) {
      case EntryKind.header:
        child = Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(timelineSideInset, 0, 16, 8),
            child: Text(
              entry.label,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
          ),
        );
      case EntryKind.chunk:
        child = Padding(
          padding: const EdgeInsets.symmetric(horizontal: timelineSideInset),
          child: JustifiedGrid(
            rows: entry.rows,
            onTap: (p) => openPhoto(context, p),
          ),
        );
      case EntryKind.placeholder:
        child = Padding(
          padding: const EdgeInsets.symmetric(horizontal: timelineSideInset),
          child: CustomPaint(
            key: ValueKey('skeleton-${entry.monthKey}'),
            painter: _SkeletonPainter(masonryCellWidth(width)),
            size: Size.infinite,
          ),
        );
    }
    return _Track(
      monthKey: entry.monthKey,
      child: SizedBox(height: entry.extent, child: child),
    );
  }
}

/// Rounded empty cells in the 3-column grid, painted only where visible: a
/// month of thousands of photos is a tall box that costs next to nothing.
class _SkeletonPainter extends CustomPainter {
  _SkeletonPainter(this.cell);

  final double cell;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.inputBg;
    final row = cell + masonryGap;
    final Rect clip = canvas.getLocalClipBounds();
    final first = (clip.top / row).floor().clamp(0, 1 << 30);
    final last = (clip.bottom / row).ceil();
    for (var r = first; r <= last; r++) {
      final y = r * row;
      if (y >= size.height) break;
      for (var c = 0; c < 3; c++) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(c * row, y, cell, cell),
            const Radius.circular(photoRadius),
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_SkeletonPainter old) => old.cell != cell;
}
