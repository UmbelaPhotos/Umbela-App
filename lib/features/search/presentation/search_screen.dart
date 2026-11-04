import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_icons.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/data/models.dart';
import '../../../core/providers.dart';
import '../../../core/timeline/timeline_controller.dart';
import '../../../core/search.dart';
import '../../../core/utils/image_helpers.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/photo_grid.dart';
import '../../people/presentation/people_tab_screen.dart';
import '../../viewer/presentation/photo_viewer_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final people = ref.watch(peopleProvider).value ?? const [];
    final albums = ref.watch(albumsProvider).value ?? const [];
    final places = ref.watch(placesProvider).value ?? const [];
    final photos = ref.watch(timelineProvider).value?.allPhotos ?? const [];
    final query = _controller.text;
    final results = search(
      query,
      people: people,
      albums: albums,
      places: places,
      photos: photos,
      personLabel: (p) => personLabel(p, people),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                children: [
                  const RoundBackButton(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      key: const ValueKey('search-field'),
                      controller: _controller,
                      autofocus: true,
                      autocorrect: false,
                      textInputAction: TextInputAction.search,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.ink,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Buscar personas, lugares o fechas...',
                        isDense: true,
                        prefixIcon: const Icon(
                          AppIcons.search,
                          size: 18,
                          color: AppColors.stem,
                        ),
                        suffixIcon: query.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () => setState(_controller.clear),
                              ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          borderSide: const BorderSide(
                            color: AppColors.floral,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _body(context, query, results, people)),
          ],
        ),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    String query,
    SearchResults r,
    List<Person> people,
  ) {
    if (query.trim().isEmpty) {
      return const _Hint(
        'Busca por nombre, lugar o fecha.\nEj.: "Mamá", "León", "agosto 2026", "ayer".',
      );
    }
    if (r.isEmpty) {
      return const _Hint('Sin resultados');
    }
    return CustomScrollView(
      slivers: [
        if (r.people.isNotEmpty)
          SliverToBoxAdapter(
            child: _Section(
              'Personas',
              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  for (final p in r.people)
                    GestureDetector(
                      key: ValueKey('result-person-${p.id}'),
                      onTap: () => context.push('/person/${p.id}'),
                      child: Column(
                        children: [
                          AvatarCircle(size: 56, seed: p.seed),
                          const SizedBox(height: 4),
                          Text(
                            personLabel(p, people),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        if (r.albums.isNotEmpty)
          SliverToBoxAdapter(
            child: _Section(
              'Álbumes',
              Column(
                children: [
                  for (final a in r.albums)
                    _Row(
                      key: ValueKey('result-album-${a.id}'),
                      icon: AppIcons.folderHeart,
                      title: a.name,
                      subtitle: '${a.photoCount} fotos',
                      onTap: () => context.push('/album/${a.id}'),
                    ),
                ],
              ),
            ),
          ),
        if (r.places.isNotEmpty)
          SliverToBoxAdapter(
            child: _Section(
              'Lugares',
              Column(
                children: [
                  for (final p in r.places)
                    _Row(
                      key: ValueKey('result-place-${p.id}'),
                      icon: AppIcons.mapPin,
                      title: p.name,
                      subtitle: '${p.photoCount} fotos',
                      onTap: () => context.go('/places'),
                    ),
                ],
              ),
            ),
          ),
        if (r.photos.isNotEmpty) ...[
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverToBoxAdapter(
              child: SectionTitle('Fotos', icon: AppIcons.image),
            ),
          ),
          ...timelineSlivers(r.photos, (p) => openPhoto(context, p, r.photos)),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 30)),
      ],
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Text(
        text,
        key: const ValueKey('search-hint'),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 13, color: AppColors.stem),
      ),
    ),
  );
}

class _Section extends StatelessWidget {
  const _Section(this.title, this.child);
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [SectionTitle(title), const SizedBox(height: 10), child],
    ),
  );
}

class _Row extends StatelessWidget {
  const _Row({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: UmbelaCard(
      radius: AppRadius.r18,
      padding: const EdgeInsets.all(8),
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(
            width: 46,
            height: 46,
            child: StripedPlaceholder(
              icon: icon,
              radius: 14,
              iconSize: 18,
              bordered: false,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11.5, color: AppColors.stem),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
