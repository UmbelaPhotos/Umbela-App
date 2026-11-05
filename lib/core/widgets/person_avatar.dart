import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../data/models.dart';
import '../providers.dart';
import '../utils/thumb_interest.dart';
import '../utils/image_helpers.dart';

/// A person's picture: the thumbnail of their cover photo in a circle. While
/// it loads, or when the person has no cover, the coloured circle is shown.
class PersonAvatar extends ConsumerWidget {
  const PersonAvatar({
    super.key,
    required this.person,
    required this.size,
    this.ring = 2.5,
  });

  final Person person;
  final double size;
  final double ring;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cover =
        ref.watch(coverOverridesProvider)['person:${person.id}'] ??
        person.coverPhotoId;
    if (cover.isNotEmpty) thumbInterest.pin(cover);
    final bytes = cover.isEmpty
        ? null
        : ref.watch(thumbnailProvider(cover)).value;
    if (bytes == null || bytes.isEmpty) {
      return AvatarCircle(size: size, ring: ring, seed: person.seed);
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.lavender, width: ring),
      ),
      child: ClipOval(
        child: Image.memory(
          bytes,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          cacheWidth: (size * 3).round(),
        ),
      ),
    );
  }
}
