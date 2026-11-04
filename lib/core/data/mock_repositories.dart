import 'dart:typed_data';

import '../security/pairing.dart';
import 'models.dart';
import 'repositories.dart';

const _latency = Duration(milliseconds: 250);

class MockData {
  MockData._();

  static const people = [
    Person(id: 'p1', name: 'Mamá', photoCount: 248, albumCount: 6, seed: 0),
    Person(id: 'p2', name: 'Carlos', photoCount: 132, albumCount: 4, seed: 1),
    Person(id: 'p3', name: 'Sofía', photoCount: 97, albumCount: 3, seed: 2),
    Person(id: 'p4', name: '', photoCount: 14, albumCount: 1, seed: 3),
  ];

  static const albums = [
    Album(id: 'a1', name: 'Familia 2026', photoCount: 312),
    Album(id: 'a2', name: 'Vacaciones', photoCount: 184),
    Album(id: 'a3', name: 'Cumpleaños Sofía', photoCount: 76, videoCover: true),
    Album(id: 'a4', name: 'Mascotas', photoCount: 58),
  ];

  static const places = [
    Place(id: 'l1', name: 'León de los Aldama, Gto.', photoCount: 428),
    Place(id: 'l2', name: 'Ciudad de México', photoCount: 156),
    Place(id: 'l3', name: 'Guanajuato Centro', photoCount: 63),
  ];

  static List<Photo> photos({int count = 22}) {
    final now = DateTime.now();
    return List.generate(count, (i) {
      final DateTime t;
      if (i < 5) {
        t = now;
      } else if (i < 10) {
        t = now.subtract(const Duration(days: 1));
      } else if (i < 16) {
        t = DateTime(now.year, now.month, 2 + (i % 3));
      } else {
        t = DateTime(now.year, now.month - 1, 20 - i % 5);
      }
      return Photo(
        id: 'ph$i',
        takenAt: t,
        isVideo: i % 7 == 2,
        tall: i % 5 == 0,
      );
    });
  }
}

class MockAuthRepository implements AuthRepository {
  @override
  Future<UnlockResult> unlock({
    required PairingData server,
    required Uint8List kek,
  }) async {
    await Future<void>.delayed(_latency);
    _unlocked = true;
    return const UnlockResult('mock-session-token');
  }

  bool _unlocked = false;

  @override
  Future<VaultStatus> status() async => VaultStatus(
    isUnlocked: _unlocked,
    expiresAt: _unlocked ? DateTime.now().add(const Duration(hours: 1)) : null,
  );

  @override
  Future<void> lock() async => _unlocked = false;
}

class MockPhotoRepository implements PhotoRepository {
  @override
  Future<List<TimelineBucket>> timelineBuckets() async {
    await Future<void>.delayed(_latency);
    final counts = <int, int>{};
    for (final p in MockData.photos()) {
      final key = p.takenAt.year * 12 + p.takenAt.month - 1;
      counts[key] = (counts[key] ?? 0) + 1;
    }
    final keys = counts.keys.toList()..sort((a, b) => b.compareTo(a));
    return [
      for (final k in keys)
        TimelineBucket(
          year: k ~/ 12,
          month: k % 12 + 1,
          count: counts[k]!,
          from: DateTime(k ~/ 12, k % 12 + 1),
          to: DateTime(
            k ~/ 12,
            k % 12 + 2,
          ).subtract(const Duration(seconds: 1)),
        ),
    ];
  }

  @override
  Future<TimelinePage> timelinePage({
    DateTime? from,
    DateTime? to,
    String cursor = '',
    int pageSize = 500,
  }) async {
    await Future<void>.delayed(_latency);
    // The demo fits in one page.
    final photos = MockData.photos()
        .where(
          (p) =>
              (from == null || !p.takenAt.isBefore(from)) &&
              (to == null || !p.takenAt.isAfter(to)),
        )
        .toList();
    return TimelinePage(photos);
  }

  @override
  Future<PhotoDetails> details(String photoId) async {
    await Future<void>.delayed(_latency);
    final photo = MockData.photos().firstWhere(
      (p) => p.id == photoId,
      orElse: () => MockData.photos().first,
    );
    return PhotoDetails(
      photo: Photo(id: photo.id, takenAt: DateTime(2026, 9, 14, 18, 42)),
      uploader: 'Valentina',
      placeName: 'León, Gto.',
      iso: 100,
      aperture: 1.8,
      encryptedAtRest: true,
      faces: const [
        FaceInPhoto(personId: 'p1', name: 'Mamá', confidence: 0.98, seed: 0),
        FaceInPhoto(personId: 'p2', name: 'Carlos', confidence: 0.94, seed: 1),
        FaceInPhoto(personId: 'p3', name: 'Sofía', confidence: 0.89, seed: 2),
      ],
    );
  }

  @override
  Future<Uint8List> thumbnail(String photoId) async => Uint8List(0);

  @override
  Future<Uint8List> fullImage(String photoId) async => Uint8List(0);

  final _favorites = <String>{};

  @override
  Future<bool> toggleFavorite(String photoId) async {
    await Future<void>.delayed(_latency);
    return _favorites.add(photoId) || !_favorites.remove(photoId);
  }

  @override
  Future<void> delete(String photoId) async {
    await Future<void>.delayed(_latency);
  }

  @override
  Future<void> addToAlbum(String photoId, String albumId) async {
    await Future<void>.delayed(_latency);
  }
}

class MockPeopleRepository implements PeopleRepository {
  final _people = [...MockData.people];

  @override
  Future<List<Person>> list() async {
    await Future<void>.delayed(_latency);
    return List.of(_people);
  }

  @override
  Future<Person> label(String personId, String name) async {
    final i = _people.indexWhere((p) => p.id == personId);
    final old = _people[i];
    final updated = Person(
      id: old.id,
      name: name,
      photoCount: old.photoCount,
      albumCount: old.albumCount,
      seed: old.seed,
    );
    _people[i] = updated;
    return updated;
  }

  @override
  Future<PersonDetails> details(String personId) async {
    await Future<void>.delayed(_latency);
    final person = _people.firstWhere((p) => p.id == personId);
    return PersonDetails(
      person: person,
      albums: MockData.albums.take(3).toList(),
      places: MockData.places.take(2).toList(),
      photos: MockData.photos(count: 14),
    );
  }

  @override
  Future<Person> setCover(String personId, String photoId) async {
    final i = _people.indexWhere((p) => p.id == personId);
    final old = _people[i];
    return _people[i] = Person(
      id: old.id,
      name: old.name,
      photoCount: old.photoCount,
      albumCount: old.albumCount,
      seed: old.seed,
      coverPhotoId: photoId,
    );
  }
}

class MockAlbumRepository implements AlbumRepository {
  final _albums = [...MockData.albums];

  @override
  Future<List<Album>> list() async {
    await Future<void>.delayed(_latency);
    return List.of(_albums);
  }

  @override
  Future<Album> create(String name) async {
    final album = Album(
      id: 'a${_albums.length + 1}',
      name: name,
      photoCount: 0,
    );
    _albums.add(album);
    return album;
  }

  @override
  Future<List<Photo>> photos(String albumId) async {
    await Future<void>.delayed(_latency);
    final album = _albums.firstWhere((a) => a.id == albumId);
    return MockData.photos(count: 8 + album.photoCount % 14);
  }

  @override
  Future<Album> setCover(String albumId, String photoId) async {
    final i = _albums.indexWhere((a) => a.id == albumId);
    final old = _albums[i];
    return _albums[i] = Album(
      id: old.id,
      name: old.name,
      photoCount: old.photoCount,
      encrypted: old.encrypted,
      videoCover: old.videoCover,
      coverPhotoId: photoId,
    );
  }
}

class MockPlaceRepository implements PlaceRepository {
  @override
  Future<List<Place>> list() async {
    await Future<void>.delayed(_latency);
    return MockData.places;
  }
}
