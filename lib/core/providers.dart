import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/connect_repositories.dart';
import 'data/mock_repositories.dart';
import 'data/models.dart';
import 'data/repositories.dart';
import 'network/connect_client.dart';
import 'network/tor_proxy_service.dart';
import 'security/kek_deriver.dart';
import 'storage/secure_storage.dart';
import 'storage/timeline_cache.dart';

/// `--dart-define=USE_MOCK=false` switches to the real Connect repositories.
const useMock = bool.fromEnvironment('USE_MOCK', defaultValue: true);

/// `--dart-define=TOR_EXTERNAL=true` uses a SOCKS5 proxy at 127.0.0.1:9050
/// instead of the embedded Arti client (emulator development).
const torExternal = bool.fromEnvironment('TOR_EXTERNAL', defaultValue: false);

/// Session token, RAM only. Null means the vault is locked.
class SessionTokenNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String token) => state = token;
  void clear() => state = null;
}

final sessionTokenProvider = NotifierProvider<SessionTokenNotifier, String?>(
  SessionTokenNotifier.new,
);

final secureStoreProvider = Provider<SecureStore>((_) => SecureStore());

final kekVaultProvider = Provider<KekVault>((_) => FlutterKekVault());

final kekDeriverProvider = Provider<KekDeriver>(
  (_) => const Argon2KekDeriver(),
);

final torProxyProvider = Provider<TorProxyService>((ref) {
  return (useMock || torExternal)
      ? ExternalSocksProxyService()
      : ArtiTorProxyService();
});

final torStatusProvider = StreamProvider<TorStatus>((ref) async* {
  final tor = ref.watch(torProxyProvider);
  yield tor.status;
  yield* tor.statusStream;
});

final connectClientProvider = Provider<ConnectClientManager>((ref) {
  final manager = ConnectClientManager(
    tor: ref.watch(torProxyProvider),
    sessionToken: () => ref.read(sessionTokenProvider),
    // The server wants a new Unlock: drop the token, the router shows login.
    onUnauthenticated: () => ref.read(sessionTokenProvider.notifier).clear(),
  );
  ref.onDispose(manager.close);
  return manager;
});

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => useMock
      ? MockAuthRepository()
      : ConnectAuthRepository(ref.watch(connectClientProvider)),
);

final photoRepositoryProvider = Provider<PhotoRepository>(
  (ref) => useMock
      ? MockPhotoRepository()
      : ConnectPhotoRepository(ref.watch(connectClientProvider)),
);

final peopleRepositoryProvider = Provider<PeopleRepository>(
  (ref) => useMock
      ? MockPeopleRepository()
      : ConnectPeopleRepository(ref.watch(connectClientProvider)),
);

final albumRepositoryProvider = Provider<AlbumRepository>(
  (ref) => useMock
      ? MockAlbumRepository()
      : ConnectAlbumRepository(ref.watch(connectClientProvider)),
);

final placeRepositoryProvider = Provider<PlaceRepository>(
  (ref) => useMock
      ? MockPlaceRepository()
      : ConnectPlaceRepository(ref.watch(connectClientProvider)),
);

final timelineCacheProvider = Provider<TimelineCache>((_) => TimelineCache());

/// True between "the phone accepted the user" (biometrics, or nothing when
/// they are off) and "the server accepted the KEK". The app is already usable
/// in that window, on cached data, while Tor starts in the background.
class PendingUnlockNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

final pendingUnlockProvider = NotifierProvider<PendingUnlockNotifier, bool>(
  PendingUnlockNotifier.new,
);

final peopleProvider = FutureProvider<List<Person>>(
  (ref) => ref.watch(peopleRepositoryProvider).list(),
);

final personDetailsProvider = FutureProvider.family<PersonDetails, String>(
  (ref, id) => ref.watch(peopleRepositoryProvider).details(id),
);

final albumsProvider = FutureProvider<List<Album>>(
  (ref) => ref.watch(albumRepositoryProvider).list(),
);

final albumPhotosProvider = FutureProvider.family<List<Photo>, String>(
  (ref, id) => ref.watch(albumRepositoryProvider).photos(id),
);

/// Covers the user just picked, shown at once while the server confirms.
/// Keys are `person:<id>` and `album:<id>`; the value is the photo id.
class CoverOverridesNotifier extends Notifier<Map<String, String>> {
  @override
  Map<String, String> build() => const {};

  void set(String key, String photoId) => state = {...state, key: photoId};

  void remove(String key) => state = {...state}..remove(key);
}

final coverOverridesProvider =
    NotifierProvider<CoverOverridesNotifier, Map<String, String>>(
      CoverOverridesNotifier.new,
    );

/// Originals are big: dropped as soon as the viewer closes.
final photoBytesProvider = FutureProvider.autoDispose.family<Uint8List, String>(
  (ref, id) => ref.watch(photoRepositoryProvider).fullImage(id),
);

/// Thumbnails are cached for the app session: re-fetching them over Tor on
/// every scroll would be slow.
final thumbnailProvider = FutureProvider.family<Uint8List, String>(
  (ref, id) => ref.watch(photoRepositoryProvider).thumbnail(id),
);

final placesProvider = FutureProvider<List<Place>>(
  (ref) => ref.watch(placeRepositoryProvider).list(),
);

final photoDetailsProvider = FutureProvider.family<PhotoDetails, String>(
  (ref, id) => ref.watch(photoRepositoryProvider).details(id),
);
