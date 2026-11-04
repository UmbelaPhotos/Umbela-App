import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';

/// Draggable handle on the right edge, like Google Photos: dragging it jumps
/// through the whole timeline and a bubble names the month under the finger.
/// It only shows while scrolling, so it never gets in the way of the photos.
class DateScrubber extends StatefulWidget {
  const DateScrubber({
    super.key,
    required this.controller,
    required this.labelAt,
    this.topInset = 8,
    this.bottomInset = 110,
  });

  final ScrollController controller;

  /// Month name for a scroll offset.
  final String Function(double offset) labelAt;
  final double topInset;
  final double bottomInset;

  @override
  State<DateScrubber> createState() => _DateScrubberState();
}

class _DateScrubberState extends State<DateScrubber> {
  static const _handleW = 32.0;
  static const _handleH = 56.0;
  static const _hideAfter = Duration(milliseconds: 1400);

  bool _active = false;
  bool _dragging = false;
  Timer? _hide;
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(DateScrubber old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller.removeListener(_onScroll);
      widget.controller.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    _hide?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (!widget.controller.hasClients) return;
    final offset = widget.controller.offset;
    final moved = offset != _lastOffset;
    _lastOffset = offset;
    if (moved) _wake();
    setState(() {});
  }

  void _wake() {
    _hide?.cancel();
    if (!_active) setState(() => _active = true);
    if (!_dragging) {
      _hide = Timer(_hideAfter, () {
        if (mounted && !_dragging) setState(() => _active = false);
      });
    }
  }

  double get _max {
    final c = widget.controller;
    return c.hasClients && c.position.hasContentDimensions
        ? c.position.maxScrollExtent
        : 0;
  }

  void _dragTo(double dy, double travel) {
    final c = widget.controller;
    if (!c.hasClients || travel <= 0) return;
    final frac = (dy / travel).clamp(0.0, 1.0);
    c.jumpTo(frac * _max);
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final max = _max;
    if (!c.hasClients || max <= 0) return const SizedBox.shrink();
    return Positioned.fill(
      top: widget.topInset,
      bottom: widget.bottomInset,
      child: LayoutBuilder(
        builder: (context, box) {
          final travel = box.maxHeight - _handleH;
          if (travel <= 0) return const SizedBox.shrink();
          final frac = (c.offset / max).clamp(0.0, 1.0);
          final top = frac * travel;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: top,
                right: 0,
                width: _handleW,
                height: _handleH,
                child: IgnorePointer(
                  ignoring: !_active,
                  child: AnimatedOpacity(
                    opacity: _active ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: GestureDetector(
                      key: const ValueKey('date-scrubber'),
                      behavior: HitTestBehavior.opaque,
                      onVerticalDragStart: (_) {
                        _hide?.cancel();
                        setState(() => _dragging = true);
                      },
                      onVerticalDragUpdate: (d) {
                        // Follow the finger: handle top = pointer - half.
                        final local = top + d.delta.dy;
                        _dragTo(local, travel);
                      },
                      onVerticalDragEnd: (_) {
                        setState(() => _dragging = false);
                        _wake();
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 8,
                          height: 40,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: AppColors.deep.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_dragging)
                Positioned(
                  top: top + (_handleH - 36) / 2,
                  right: _handleW + 6,
                  child: IgnorePointer(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.deep,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.labelAt(c.offset),
                        key: const ValueKey('scrubber-label'),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
