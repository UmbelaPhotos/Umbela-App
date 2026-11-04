import 'dart:typed_data';

import '../security/pairing.dart';
import 'models.dart';

class TimelinePage {
  const TimelinePage(this.photos, [this.nextCursor = '']);
  final List<Photo> photos;

  /// Empty on the last page.
  final String nextCursor;
}

abstract class PhotoRepository {
  /// Photo count per month, newest first. A few KB for the whole library.
  Future<List<TimelineBucket>> timelineBuckets();

  /// One page of photos taken in [from]..[to] (open when null), newest first.
  /// Pass the previous page's `nextCursor` to continue; empty means the start.
  Future<TimelinePage> timelinePage({
    DateTime? from,
    DateTime? to,
    String cursor = '',
    int pageSize = 500,
  });
  Future<PhotoDetails> details(String photoId);
  Future<Uint8List> thumbnail(String photoId);
  Future<Uint8List> fullImage(String photoId);

  /// Flips the favorite flag and returns the new value.
  Future<bool> toggleFavorite(String photoId);
  Future<void> delete(String photoId);
  Future<void> addToAlbum(String photoId, String albumId);
}

abstract class PeopleRepository {
  Future<List<Person>> list();
  Future<Person> label(String personId, String name);
  Future<PersonDetails> details(String personId);

  /// Makes [photoId] the person's picture.
  Future<Person> setCover(String personId, String photoId);
}

abstract class AlbumRepository {
  Future<List<Album>> list();
  Future<Album> create(String name);
  Future<List<Photo>> photos(String albumId);

  /// Makes [photoId] the album's picture.
  Future<Album> setCover(String albumId, String photoId);
}

abstract class PlaceRepository {
  Future<List<Place>> list();
}

class VaultStatus {
  const VaultStatus({required this.isUnlocked, required this.expiresAt});
  final bool isUnlocked;
  final DateTime? expiresAt;
}

class UnlockResult {
  const UnlockResult(this.sessionToken);
  final String sessionToken;
}

abstract class AuthRepository {
  /// Sends the KEK once and returns the RAM-only session token that replaces
  /// it on every later call.
  Future<UnlockResult> unlock({
    required PairingData server,
    required Uint8List kek,
  });

  Future<VaultStatus> status();

  /// Locks the vault right away; the server drops the session token and KEK.
  Future<void> lock();
}
