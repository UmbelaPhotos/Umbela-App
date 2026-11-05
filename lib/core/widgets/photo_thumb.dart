import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_icons.dart';
import '../data/models.dart';
import '../providers.dart';
import '../utils/image_helpers.dart';
import '../utils/thumb_interest.dart';

const photoRadius = 8.0;

/// How long a cell must stay on screen before its thumbnail is requested, so
/// scrolling quickly past thousands of photos costs no Tor traffic.
const thumbDelay = Duration(milliseconds: 300);

/// Grid cell: blurhash first, then the real thumbnail fades in over it once
/// the cell has stayed on screen for a moment.
class PhotoThumb extends ConsumerStatefulWidget {
  const PhotoThumb(this.photo, {super.key, this.iconSize = 22});
  final Photo photo;
  final double iconSize;

  @override
  ConsumerState<PhotoThumb> createState() => _PhotoThumbState();
}

class _PhotoThumbState extends ConsumerState<PhotoThumb> {
  Timer? _timer;
  Timer? _retryTimer;
  bool _wantThumb = false;

  /// False while another screen (the photo viewer) covers this one: nothing
  /// here is on screen, so it must not take connections from the viewer.
  bool _active = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final active = TickerMode.valuesOf(context).enabled;
    if (active && !_active) thumbInterest.wake();
    _active = active;
  }

  /// How urgent this cell is: its distance from the top of the screen when it
  /// is on screen, then a long way after that for cells just outside it.
  double? _priority() {
    if (!mounted || !_active) return null;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) {
      return 1e8;
    }
    final pos = box.localToGlobal(Offset.zero);
    final view = View.of(context);
    final screen = view.physicalSize.height / view.devicePixelRatio;
    if (pos.dy + box.size.height <= 0) return 1e4 - (pos.dy + box.size.height);
    if (pos.dy >= screen) return 1e4 + (pos.dy - screen);
    // Row by row from the top, left to right inside a row.
    return (pos.dy < 0 ? 0 : pos.dy) + pos.dx * 0.001;
  }

  @override
  void initState() {
    super.initState();
    thumbInterest.register(widget.photo.id, _priority);
    // Already fetched earlier (scrolled back to it): show it right away.
    final id = widget.photo.id;
    if (ref.exists(thumbnailProvider(id))) {
      // A failed fetch is not kept: ask again.
      if (ref.read(thumbnailProvider(id)).hasError) {
        Future.microtask(() {
          if (mounted) ref.invalidate(thumbnailProvider(id));
        });
      }
      _wantThumb = true;
    } else {
      _timer = Timer(thumbDelay, () {
        if (mounted) setState(() => _wantThumb = true);
      });
    }
  }

  @override
  void dispose() {
    thumbInterest.unregister(widget.photo.id, _priority);
    _timer?.cancel();
    _retryTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final photo = widget.photo;
    final iconSize = widget.iconSize;
    if (_wantThumb) {
      // The fetch already retried on its own and still failed: try once more
      // in a while, as long as this cell stays on screen.
      ref.listen(thumbnailProvider(photo.id), (_, next) {
        if (!next.hasError) return;
        _retryTimer?.cancel();
        _retryTimer = Timer(const Duration(seconds: 8), () {
          if (mounted) ref.invalidate(thumbnailProvider(photo.id));
        });
      });
    }
    final bytes = _wantThumb
        ? ref.watch(thumbnailProvider(photo.id)).value
        : null;
    final hasThumb = bytes != null && bytes.isNotEmpty;
    return ClipRRect(
      borderRadius: BorderRadius.circular(photoRadius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (photo.blurhash.isNotEmpty)
            BlurHash(hash: photo.blurhash)
          else
            StripedPlaceholder(
              icon: photo.isVideo ? AppIcons.video : AppIcons.image,
              iconSize: iconSize,
              radius: photoRadius,
            ),
          if (hasThumb)
            Image.memory(
              bytes,
              fit: BoxFit.cover,
              gaplessPlayback: true,
              cacheWidth: 360,
              frameBuilder: (_, child, frame, sync) => AnimatedOpacity(
                opacity: sync || frame != null ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: child,
              ),
            ),
          if (photo.isVideo && (hasThumb || photo.blurhash.isNotEmpty))
            const Center(
              child: Icon(AppIcons.video, size: 22, color: Colors.white),
            ),
        ],
      ),
    );
  }
}
