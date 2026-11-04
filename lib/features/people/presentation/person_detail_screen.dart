import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_icons.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/data/models.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/album_cover.dart';
import '../../../core/widgets/map_widgets.dart';
import '../../../core/widgets/pick_cover_banner.dart';
import '../../../core/widgets/person_avatar.dart';
import '../../../core/widgets/photo_grid.dart';
import 'people_tab_screen.dart';
import '../../viewer/presentation/photo_viewer_screen.dart';

class PersonDetailScreen extends ConsumerStatefulWidget {
  const PersonDetailScreen({super.key, required this.personId});

  final String personId;

  @override
  ConsumerState<PersonDetailScreen> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends ConsumerState<PersonDetailScreen> {
  /// True while the user is choosing the picture: a tap on a photo picks it.
  bool _picking = false;

  Future<void> _setCover(Photo photo) async {
    setState(() => _picking = false);
    // The screen may be closed before the server answers: keep using the
    // container, not this widget's ref.
    final container = ProviderScope.containerOf(context);
    final key = 'person:${widget.personId}';
    final overrides = container.read(coverOverridesProvider.notifier);
    overrides.set(key, photo.id); // optimistic: shown right away
    try {
      await container
          .read(peopleRepositoryProvider)
          .setCover(widget.personId, photo.id);
    } catch (_) {
      overrides.remove(key);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo cambiar la foto principal')),
        );
      }
      return;
    }
    container.invalidate(peopleProvider);
    container.invalidate(personDetailsProvider(widget.personId));
    try {
      await Future.wait([
        container.read(peopleProvider.future),
        container.read(personDetailsProvider(widget.personId).future),
      ]);
    } catch (_) {}
    overrides.remove(key);
  }

  Future<void> _rename(BuildContext context, WidgetRef ref, Person p) async {
    final controller = TextEditingController(text: p.name);
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r28),
        ),
        title: const Text('Nombre de la persona'),
        content: TextField(
          key: const ValueKey('person-name'),
          controller: controller,
          autofocus: true,
          maxLength: 100,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            hintText: 'Nombre (vacío para quitarlo)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (name == null || name == p.name) return;
    try {
      await ref.read(peopleRepositoryProvider).label(p.id, name);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo guardar el nombre')),
        );
      }
      return;
    }
    ref.invalidate(peopleProvider);
    ref.invalidate(personDetailsProvider(p.id));
  }

  @override
  Widget build(BuildContext context) {
    final personId = widget.personId;
    final details = ref.watch(personDetailsProvider(personId));
    final all = ref.watch(peopleProvider).value ?? const <Person>[];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: details.when(
        skipLoadingOnReload: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => SafeArea(
          child: ErrorView(
            error: e,
            onRetry: () => reloadProvider(ref, personDetailsProvider(personId)),
          ),
        ),
        data: (d) => PullRefresh(
          onRefresh: () => reloadProvider(ref, personDetailsProvider(personId)),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _Header(
                  d,
                  personLabel(d.person, all),
                  onRename: () => _rename(context, ref, d.person),
                  onPickCover: () => setState(() => _picking = true),
                ),
              ),
              if (_picking)
                SliverToBoxAdapter(
                  child: PickCoverBanner(
                    onCancel: () => setState(() => _picking = false),
                  ),
                ),
              SliverToBoxAdapter(child: _Albums(d.albums)),
              SliverToBoxAdapter(child: _Places(d.places)),
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(16, 18, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: SectionTitle('Fototeca', icon: AppIcons.image),
                ),
              ),
              ...timelineSlivers(
                d.photos,
                (p) =>
                    _picking ? _setCover(p) : openPhoto(context, p, d.photos),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(
    this.d,
    this.name, {
    required this.onRename,
    required this.onPickCover,
  });
  final PersonDetails d;
  final String name;
  final VoidCallback onRename;
  final VoidCallback onPickCover;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 10,
        16,
        18,
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
          Transform.translate(
            offset: const Offset(0, -20),
            child: Column(
              children: [
                GestureDetector(
                  key: const ValueKey('person-cover'),
                  onTap: onPickCover,
                  child: PersonAvatar(person: d.person, size: 76, ring: 3),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  key: const ValueKey('rename-person'),
                  behavior: HitTestBehavior.opaque,
                  onTap: onRename,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        AppIcons.pencil,
                        size: 16,
                        color: AppColors.stem,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${d.person.photoCount} fotos · ${d.albums.length} álbumes',
                  style: const TextStyle(fontSize: 12.5, color: AppColors.stem),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Albums extends StatelessWidget {
  const _Albums(this.albums);
  final List<Album> albums;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SectionTitle(
              'Álbumes donde aparece',
              icon: AppIcons.folderHeart,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 50,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: albums.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final a = albums[i];
                return UmbelaCard(
                  key: ValueKey('album-chip-${a.id}'),
                  radius: AppRadius.r16,
                  padding: const EdgeInsets.fromLTRB(6, 6, 14, 6),
                  onTap: () => context.push('/album/${a.id}'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: AlbumCover(
                          album: a,
                          radius: 12,
                          iconSize: 14,
                          bordered: false,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        a.name,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Places extends StatelessWidget {
  const _Places(this.places);
  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Lugares donde ha estado', icon: AppIcons.mapPin),
          const SizedBox(height: 10),
          Row(
            children: [
              for (var i = 0; i < places.length && i < 2; i++) ...[
                if (i > 0) const SizedBox(width: 12),
                Expanded(child: _PlaceCard(places[i])),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  const _PlaceCard(this.place);
  final Place place;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: GestureDetector(
        key: ValueKey('place-card-${place.id}'),
        onTap: () => context.go('/places'),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              const Positioned.fill(
                child: CustomPaint(painter: GridMapPainter()),
              ),
              const Align(
                alignment: Alignment(0, -0.35),
                child: MapPinMarker(size: 26),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  color: Colors.white.withValues(alpha: 0.85),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      Text(
                        '${place.photoCount} fotos',
                        style: const TextStyle(
                          fontSize: 9.5,
                          color: AppColors.stem,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
