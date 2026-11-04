import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_icons.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/data/models.dart';
import '../../../core/providers.dart';
import '../../../core/utils/image_helpers.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/map_widgets.dart';

class PlacesTabScreen extends ConsumerWidget {
  const PlacesTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final places = ref.watch(placesProvider);
    return ColoredBox(
      color: AppColors.background,
      child: places.when(
        skipLoadingOnReload: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => SafeArea(
          child: ErrorView(
            error: e,
            onRetry: () => reloadProvider(ref, placesProvider),
          ),
        ),
        data: (list) => Column(
          children: [
            SizedBox(height: 250, child: _MapArea(list)),
            Expanded(
              child: PullRefresh(
                onRefresh: () => reloadProvider(ref, placesProvider),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                  children: [
                    const Text(
                      'Lugares',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (final p in list) ...[
                      _PlaceRow(p),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapArea extends StatelessWidget {
  const _MapArea(this.places);
  final List<Place> places;

  // Normalised positions: the prototype has no real map tiles.
  static const _spots = [
    Offset(0.52, 0.34),
    Offset(0.66, 0.52),
    Offset(0.32, 0.62),
    Offset(0.80, 0.70),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        return Stack(
          children: [
            const Positioned.fill(
              child: CustomPaint(painter: GridMapPainter()),
            ),
            for (var i = 0; i < _spots.length; i++)
              Positioned(
                left: c.maxWidth * _spots[i].dx - 17,
                top: c.maxHeight * _spots[i].dy - 20,
                child: MapPinMarker(
                  key: ValueKey('pin-$i'),
                  size: i == 0 || i == 3 ? 34 : 26,
                  // Prototype destination, as in the guide: Álbumes.
                  onTap: () => context.go('/albums'),
                ),
              ),
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: AppHeader(translucent: true),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PlaceRow extends StatelessWidget {
  const _PlaceRow(this.place);
  final Place place;

  @override
  Widget build(BuildContext context) {
    return UmbelaCard(
      key: ValueKey('place-${place.id}'),
      radius: AppRadius.r18,
      padding: const EdgeInsets.all(8),
      onTap: () => context.go('/albums'),
      child: Row(
        children: [
          const SizedBox(
            width: 50,
            height: 50,
            child: StripedPlaceholder(
              icon: AppIcons.image,
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
                  place.name,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  '${place.photoCount} fotos',
                  style: const TextStyle(fontSize: 11.5, color: AppColors.stem),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
