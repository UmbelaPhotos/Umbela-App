import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_icons.dart';
import '../data/models.dart';
import '../providers.dart';
import '../utils/thumb_interest.dart';
import '../utils/image_helpers.dart';

/// An album's picture: the thumbnail of its cover photo. While it loads, or
/// when the album has no cover, the striped placeholder is shown.
class AlbumCover extends ConsumerWidget {
  const AlbumCover({
    super.key,
    required this.album,
    this.radius = 14,
    this.iconSize = 24,
    this.bordered = true,
  });

  final Album? album;
  final double radius;
  final double iconSize;
  final bool bordered;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placeholder = StripedPlaceholder(
      icon: (album?.videoCover ?? false) ? AppIcons.video : AppIcons.image,
      radius: radius,
      iconSize: iconSize,
      bordered: bordered,
    );
    final cover =
        ref.watch(coverOverridesProvider)['album:${album?.id}'] ??
        album?.coverPhotoId ??
        '';
    if (cover.isNotEmpty) thumbInterest.pin(cover);
    final bytes = cover.isEmpty
        ? null
        : ref.watch(thumbnailProvider(cover)).value;
    if (bytes == null || bytes.isEmpty) return placeholder;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.memory(
        bytes,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        cacheWidth: 360,
      ),
    );
  }
}
