import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_icons.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/data/models.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/album_cover.dart';
import '../../../core/widgets/common.dart';

class AlbumsTabScreen extends ConsumerWidget {
  const AlbumsTabScreen({super.key});

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r28),
        ),
        title: const Text('Nuevo álbum'),
        content: TextField(
          key: const ValueKey('new-album-name'),
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Nombre del álbum'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Crear'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;
    await ref.read(albumRepositoryProvider).create(name);
    ref.invalidate(albumsProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albums = ref.watch(albumsProvider);
    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const ColoredBox(
              color: Colors.white,
              child: SizedBox(width: double.infinity, child: AppHeader()),
            ),
            Expanded(
              child: albums.when(
                skipLoadingOnReload: true,
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => ErrorView(
                  error: e,
                  onRetry: () => reloadProvider(ref, albumsProvider),
                ),
                data: (list) => PullRefresh(
                  onRefresh: () => reloadProvider(ref, albumsProvider),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                    children: [
                      const Text(
                        'Álbumes',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 12),
                      PillButton(
                        label: 'Crear álbum',
                        icon: AppIcons.plus,
                        onPressed: () => _create(context, ref),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.82,
                        children: [for (final a in list) _AlbumCard(a)],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlbumCard extends StatelessWidget {
  const _AlbumCard(this.album);
  final Album album;

  @override
  Widget build(BuildContext context) {
    return UmbelaCard(
      key: ValueKey('album-${album.id}'),
      radius: AppRadius.r22,
      onTap: () => context.push('/album/${album.id}'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.r22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: AlbumCover(
                  album: album,
                  radius: 0,
                  iconSize: 30,
                  bordered: false,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (album.encrypted)
                        const Padding(
                          padding: EdgeInsets.only(top: 2, right: 5),
                          child: Icon(
                            AppIcons.lock,
                            size: 12,
                            color: AppColors.stem,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          album.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${album.photoCount} fotos',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.stem,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
