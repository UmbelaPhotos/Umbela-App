import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_icons.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/data/models.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/album_cover.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/pick_cover_banner.dart';
import '../../../core/widgets/photo_grid.dart';
import '../../viewer/presentation/photo_viewer_screen.dart';

/// One album: a cover and name on top, then its photos by date, like Fotos.
class AlbumDetailScreen extends ConsumerStatefulWidget {
  const AlbumDetailScreen({super.key, required this.albumId});

  final String albumId;

  @override
  ConsumerState<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends ConsumerState<AlbumDetailScreen> {
  /// True while the user is choosing the cover: a tap on a photo picks it.
  bool _picking = false;

  Future<void> _setCover(Photo p) async {
    setState(() => _picking = false);
    // The screen may be closed before the server answers: keep using the
    // container, not this widget's ref.
    final container = ProviderScope.containerOf(context);
    final key = 'album:${widget.albumId}';
    final overrides = container.read(coverOverridesProvider.notifier);
    overrides.set(key, p.id); // optimistic: shown right away
    try {
      await container
          .read(albumRepositoryProvider)
          .setCover(widget.albumId, p.id);
    } catch (_) {
      overrides.remove(key);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo cambiar la foto principal')),
        );
      }
      return;
    }
    container.invalidate(albumsProvider);
    try {
      await container.read(albumsProvider.future);
    } catch (_) {}
    overrides.remove(key);
  }

  @override
  Widget build(BuildContext context) {
    final albumId = widget.albumId;
    final albums = ref.watch(albumsProvider);
    final photos = ref.watch(albumPhotosProvider(albumId));
    final album = albums.value?.where((a) => a.id == albumId).firstOrNull;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: PullRefresh(
        onRefresh: () => reloadProvider(ref, albumPhotosProvider(albumId)),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _Header(
                album,
                onPickCover: () => setState(() => _picking = true),
              ),
            ),
            if (_picking)
              SliverToBoxAdapter(
                child: PickCoverBanner(
                  onCancel: () => setState(() => _picking = false),
                ),
              ),
            ...photos.when(
              skipLoadingOnReload: true,
              loading: () => [
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
              error: (e, _) => [
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No se pudo cargar. Desliza hacia abajo para reintentar.\n$e',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
              data: (list) => [
                ...timelineSlivers(
                  list,
                  (p) => _picking ? _setCover(p) : openPhoto(context, p, list),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.album, {required this.onPickCover});
  final Album? album;
  final VoidCallback onPickCover;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 10,
        16,
        20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppRadius.r28),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: RoundBackButton(),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              GestureDetector(
                key: const ValueKey('album-cover'),
                onTap: onPickCover,
                child: SizedBox(
                  width: 76,
                  height: 76,
                  child: AlbumCover(
                    album: album,
                    radius: AppRadius.r22,
                    iconSize: 26,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (album?.encrypted ?? false)
                          const Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: Icon(
                              AppIcons.lock,
                              size: 15,
                              color: AppColors.stem,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            album?.name ?? '',
                            key: const ValueKey('album-title'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${album?.photoCount ?? 0} fotos',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.stem,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
