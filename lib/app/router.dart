import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/data/models.dart';
import '../core/providers.dart';
import '../features/albums/presentation/album_detail_screen.dart';
import '../features/albums/presentation/albums_tab_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/qr_scan_screen.dart';
import '../features/navigation/presentation/main_navigation_wrapper.dart';
import '../features/people/presentation/people_tab_screen.dart';
import '../features/people/presentation/person_detail_screen.dart';
import '../features/places/presentation/places_tab_screen.dart';
import '../features/search/presentation/search_screen.dart';
import '../features/timeline/presentation/photos_tab_screen.dart';
import '../features/viewer/presentation/photo_viewer_screen.dart';

Page<void> _tab(GoRouterState s, Widget child) =>
    NoTransitionPage(key: s.pageKey, child: child);

final routerProvider = Provider<GoRouter>((ref) {
  // Locked (token cleared) always lands on /login; unlocked never stays there.
  final refresh = ValueNotifier<int>(0);
  ref.listen(sessionTokenProvider, (_, _) => refresh.value++);
  ref.listen(pendingUnlockProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  final router = GoRouter(
    initialLocation: '/login',
    refreshListenable: refresh,
    redirect: (context, state) {
      // A pending unlock (phone verified, server still connecting) is let in.
      final unlocked =
          ref.read(sessionTokenProvider) != null ||
          ref.read(pendingUnlockProvider);
      final atLogin = state.matchedLocation == '/login';
      // Pairing happens before unlocking, so /scan is open while locked.
      if (!unlocked) {
        return (atLogin || state.matchedLocation == '/scan') ? null : '/login';
      }
      if (atLogin) return '/photos';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/scan', builder: (_, _) => const QrScanScreen()),
      // Tabs stay alive (scroll position, loaded photos) when switching.
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => MainNavigationWrapper(child: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/photos',
                pageBuilder: (_, s) => _tab(s, const PhotosTabScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/people',
                pageBuilder: (_, s) => _tab(s, const PeopleTabScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/albums',
                pageBuilder: (_, s) => _tab(s, const AlbumsTabScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/places',
                pageBuilder: (_, s) => _tab(s, const PlacesTabScreen()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(path: '/search', builder: (_, _) => const SearchScreen()),
      GoRoute(
        path: '/album/:id',
        builder: (_, s) => AlbumDetailScreen(albumId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/person/:id',
        builder: (_, s) =>
            PersonDetailScreen(personId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/photo/:id',
        builder: (_, s) => PhotoViewerScreen(
          photoId: s.pathParameters['id']!,
          initial: switch (s.extra) {
            ViewerArgs a => a.photo,
            Photo p => p,
            _ => null,
          },
          photos: s.extra is ViewerArgs ? (s.extra as ViewerArgs).photos : null,
        ),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
