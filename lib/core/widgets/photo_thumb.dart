import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_icons.dart';
import '../data/models.dart';
import '../providers.dart';
import '../utils/image_helpers.dart';

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
  bool _wantThumb = false;

  @override
  void initState() {
    super.initState();
    // Already fetched earlier (scrolled back to it): show it right away.
    if (ref.exists(thumbnailProvider(widget.photo.id))) {
      _wantThumb = true;
    } else {
      _timer = Timer(thumbDelay, () {
        if (mounted) setState(() => _wantThumb = true);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final photo = widget.photo;
    final iconSize = widget.iconSize;
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
