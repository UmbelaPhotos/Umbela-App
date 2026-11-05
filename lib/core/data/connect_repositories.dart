import 'package:flutter/foundation.dart' show debugPrint;

import 'dart:async';
import 'dart:io' show SocketException;
import 'dart:math';
import 'dart:typed_data';

import 'package:connectrpc/connect.dart' show Code, ConnectException;
import 'package:fixnum/fixnum.dart';

import '../../gen/v1/auth.pb.dart' as auth;
import '../../gen/v1/photo.pb.dart' as pb;
import '../network/connect_client.dart';
import '../security/pairing.dart';
import '../security/server_identity.dart';
import '../utils/priority_gate.dart';
import '../utils/thumb_interest.dart';
import 'models.dart';
import 'repositories.dart';

Photo _photo(pb.PhotoSummary p) => Photo(
  id: p.id,
  takenAt: DateTime.fromMillisecondsSinceEpoch(p.takenAtUnix.toInt() * 1000),
  isVideo: p.isVideo,
  tall: p.height > p.width,
  blurhash: p.blurhash,
  aspect: p.height > 0 ? p.width / p.height : 0,
);

Person _person(pb.PersonSummary p, {int albums = 0}) => Person(
  id: p.id,
  name: p.name,
  photoCount: p.photoCount,
  albumCount: albums,
  seed: p.id.hashCode.abs(),
  coverPhotoId: p.coverPhotoId,
);

Album _album(pb.AlbumSummary a) => Album(
  id: a.id,
  name: a.name,
  photoCount: a.photoCount,
  encrypted: a.encrypted,
  videoCover: a.hasVideoCover,
  coverPhotoId: a.coverPhotoId,
);

Place _place(pb.PlaceSummary p) => Place(
  id: p.id,
  name: p.name,
  photoCount: p.photoCount,
  latitude: p.latitude,
  longitude: p.longitude,
);

Future<Uint8List> _collect(
  Stream<pb.Chunk> chunks, {
  Duration? stall,
  bool Function()? abandon,
}) async {
  final out = BytesBuilder(copy: false);
  // With [stall], a stream that goes quiet that long fails with a
  // TimeoutException (and is cancelled) instead of hanging forever.
  // With [abandon], a request that has not got its first bytes after a few
  // seconds is dropped as soon as nobody wants the result any more.
  final started = Stopwatch()..start();
  final timed = stall == null ? chunks : chunks.timeout(stall);
  final stream = abandon == null
      ? timed
      : _abortable(
          timed,
          () => out.isEmpty && started.elapsed > _abandonAfter && abandon(),
        );
  await for (final c in stream) {
    out.add(c.data);
  }
  return out.takeBytes();
}

const _abandonAfter = Duration(seconds: 3);

class _Abandoned implements Exception {
  @override
  String toString() => 'Petición abandonada: ya no se necesita.';
}

/// [source] until [shouldStop] turns true (checked once a second): then the
/// source is cancelled and the stream fails with [_Abandoned].
Stream<T> _abortable<T>(Stream<T> source, bool Function() shouldStop) async* {
  final ctrl = StreamController<T>();
  final sub = source.listen(
    ctrl.add,
    onError: ctrl.addError,
    onDone: ctrl.close,
  );
  final timer = Timer.periodic(const Duration(seconds: 1), (_) {
    if (ctrl.isClosed || !shouldStop()) return;
    sub.cancel();
    ctrl.addError(_Abandoned());
    ctrl.close();
  });
  try {
    yield* ctrl.stream;
  } finally {
    timer.cancel();
    await sub.cancel();
  }
}

/// Thrown when the server does not hold the key from the pairing QR. The KEK
/// must never be sent in that case.
class ServerIdentityException implements Exception {
  @override
  String toString() => 'No se pudo verificar la identidad del servidor.';
}

class ConnectAuthRepository implements AuthRepository {
  ConnectAuthRepository(this._client, {Random? random})
    : _random = random ?? Random.secure();

  final ConnectClientManager _client;
  final Random _random;

  @override
  Future<UnlockResult> unlock({
    required PairingData server,
    required Uint8List kek,
  }) async {
    await _client.connect(server);

    final nonce = Uint8List.fromList(
      List.generate(32, (_) => _random.nextInt(256)),
    );
    final proof = await _client.auth.identify(
      auth.IdentifyRequest(nonce: nonce),
    );
    final ok = await verifyServerIdentity(
      serverKey: server.serverKey,
      nonce: nonce,
      signature: Uint8List.fromList(proof.signature),
    );
    if (!ok) throw ServerIdentityException();

    final res = await _client.auth.unlock(auth.UnlockRequest(kek: kek));
    return UnlockResult(res.sessionToken);
  }

  @override
  Future<VaultStatus> status() async {
    final res = await _client.auth.getStatus(auth.GetStatusRequest());
    return VaultStatus(
      isUnlocked: res.isUnlocked,
      expiresAt: res.expiresAtUnix == 0
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
              res.expiresAtUnix.toInt() * 1000,
            ),
    );
  }

  @override
  Future<void> lock() async {
    await _client.auth.lock(auth.LockRequest());
  }
}

class ConnectPhotoRepository implements PhotoRepository {
  ConnectPhotoRepository(this._client);
  final ConnectClientManager _client;

  @override
  Future<List<TimelineBucket>> timelineBuckets() async {
    final res = await _client.photos.getTimelineBuckets(
      pb.GetTimelineBucketsRequest(
        tzOffsetSeconds: DateTime.now().timeZoneOffset.inSeconds,
      ),
    );
    DateTime at(Int64 unix) =>
        DateTime.fromMillisecondsSinceEpoch(unix.toInt() * 1000);
    return [
      for (final b in res.buckets)
        TimelineBucket(
          year: b.year,
          month: b.month,
          count: b.count,
          from: at(b.fromUnix),
          to: at(b.toUnix),
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
    Int64? unix(DateTime? t) =>
        t == null ? null : Int64(t.millisecondsSinceEpoch ~/ 1000);
    final res = await _client.photos.getTimeline(
      pb.GetTimelineRequest(
        fromUnix: unix(from),
        toUnix: unix(to),
        cursor: cursor,
        pageSize: pageSize,
      ),
    );
    return TimelinePage(res.photos.map(_photo).toList(), res.nextCursor);
  }

  @override
  Future<PhotoDetails> details(String photoId) async {
    final res = await _client.photos.getPhotoDetails(
      pb.GetPhotoDetailsRequest(photoId: photoId),
    );
    final d = res.photo;
    return PhotoDetails(
      photo: _photo(d.summary),
      uploader: d.uploader,
      placeName: d.placeName,
      iso: d.iso,
      aperture: d.aperture,
      encryptedAtRest: d.encryptedAtRest,
      favorite: d.favorite,
      faces: [
        for (final f in d.faces)
          FaceInPhoto(
            personId: f.personId,
            name: f.name,
            confidence: f.confidence,
            seed: f.personId.hashCode.abs(),
          ),
      ],
    );
  }

  /// Thumbnails share a few slots. The next one is the cell nearest the top
  /// of the screen (see [ThumbInterest]); cells that scrolled away wait.
  /// A full image or a page of details never queues behind them.
  late final _thumbGate = _makeThumbGate();

  PriorityGate _makeThumbGate() {
    final gate = PriorityGate(4);
    thumbInterest.addListener(gate.nudge);
    return gate;
  }

  /// No data at all for this long and the request is given up on.
  static const _thumbStall = Duration(seconds: 15);
  static const _thumbRetryDelays = [Duration(seconds: 1), Duration(seconds: 3)];

  @override
  Future<Uint8List> thumbnail(String photoId) async {
    final queued = Stopwatch()..start(); // [perf]
    for (var attempt = 0; ; attempt++) {
      try {
        return await _thumbGate.run(() {
          debugPrint(
            '[perf] thumb ${photoId.substring(0, 8)}: '
            'queue=${queued.elapsedMilliseconds}ms',
          ); // [perf]
          return _fetchThumbnail(photoId);
        }, priority: () => thumbInterest.priorityOf(photoId));
      } catch (e) {
        if (attempt >= _thumbRetryDelays.length || !_retryable(e)) rethrow;
        debugPrint(
          '[perf] thumb ${photoId.substring(0, 8)}: retry ${attempt + 1} ($e)',
        ); // [perf]
        // The slot is free while we wait, so others are not held up.
        await Future<void>.delayed(_thumbRetryDelays[attempt]);
      }
    }
  }

  Future<Uint8List> _fetchThumbnail(String photoId) async {
    final started = Stopwatch()..start(); // [perf]
    final bytes = await _collect(
      _client.photos.streamThumbnail(
        pb.GetThumbnailRequest(photoId: photoId, maxSize: 300),
      ),
      stall: _thumbStall,
      abandon: () => thumbInterest.priorityOf(photoId) == null,
    );
    debugPrint(
      '[perf] thumb ${photoId.substring(0, 8)}: ${bytes.length ~/ 1024} KB, '
      'fetch=${started.elapsedMilliseconds}ms',
    ); // [perf]
    return bytes;
  }

  /// Network trouble is worth another go; a definite answer from the server
  /// (not found, not allowed, session expired) is not.
  static bool _retryable(Object e) {
    if (e is _Abandoned) return false;
    if (e is ConnectException) {
      return switch (e.code) {
        Code.notFound ||
        Code.unauthenticated ||
        Code.permissionDenied ||
        Code.invalidArgument ||
        Code.canceled => false,
        _ => true,
      };
    }
    return (e is TimeoutException || e is SocketException) && e is! _Abandoned;
  }

  @override
  Future<Uint8List> fullImage(String photoId) => _collect(
    _client.photos.streamFullImage(pb.GetFullImageRequest(photoId: photoId)),
  );

  @override
  Future<bool> toggleFavorite(String photoId) async {
    final res = await _client.photos.toggleFavorite(
      pb.ToggleFavoriteRequest(photoId: photoId),
    );
    return res.isFavorite;
  }

  @override
  Future<void> delete(String photoId) async {
    await _client.photos.deletePhoto(pb.DeletePhotoRequest(photoId: photoId));
  }

  @override
  Future<void> addToAlbum(String photoId, String albumId) async {
    await _client.photos.addPhotoToAlbum(
      pb.AddPhotoToAlbumRequest(photoId: photoId, albumId: albumId),
    );
  }
}

class ConnectPeopleRepository implements PeopleRepository {
  ConnectPeopleRepository(this._client);
  final ConnectClientManager _client;

  @override
  Future<List<Person>> list() async {
    final res = await _client.photos.listPeople(pb.ListPeopleRequest());
    return res.people.map(_person).toList();
  }

  @override
  Future<Person> label(String personId, String name) async {
    final res = await _client.photos.labelPerson(
      pb.LabelPersonRequest(personId: personId, name: name),
    );
    return _person(res.person);
  }

  @override
  Future<PersonDetails> details(String personId) async {
    final res = await _client.photos.getPersonDetails(
      pb.GetPersonDetailsRequest(personId: personId),
    );
    return PersonDetails(
      person: _person(res.person, albums: res.albums.length),
      albums: res.albums.map(_album).toList(),
      places: res.places.map(_place).toList(),
      photos: res.photos.map(_photo).toList(),
    );
  }

  @override
  Future<Person> setCover(String personId, String photoId) async {
    final res = await _client.photos.setPersonCover(
      pb.SetPersonCoverRequest(personId: personId, photoId: photoId),
    );
    return _person(res.person);
  }
}

class ConnectAlbumRepository implements AlbumRepository {
  ConnectAlbumRepository(this._client);
  final ConnectClientManager _client;

  @override
  Future<List<Album>> list() async {
    final res = await _client.photos.listAlbums(pb.ListAlbumsRequest());
    return res.albums.map(_album).toList();
  }

  @override
  Future<Album> create(String name) async {
    final res = await _client.photos.createAlbum(
      pb.CreateAlbumRequest(name: name),
    );
    return _album(res.album);
  }

  @override
  Future<List<Photo>> photos(String albumId) async {
    final photos = <Photo>[];
    var cursor = '';
    do {
      final res = await _client.photos.getTimeline(
        pb.GetTimelineRequest(albumId: albumId, cursor: cursor, pageSize: 500),
      );
      photos.addAll(res.photos.map(_photo));
      cursor = res.photos.isEmpty ? '' : res.nextCursor;
    } while (cursor.isNotEmpty);
    return photos;
  }

  @override
  Future<Album> setCover(String albumId, String photoId) async {
    final res = await _client.photos.setAlbumCover(
      pb.SetAlbumCoverRequest(albumId: albumId, photoId: photoId),
    );
    return _album(res.album);
  }
}

class ConnectPlaceRepository implements PlaceRepository {
  ConnectPlaceRepository(this._client);
  final ConnectClientManager _client;

  @override
  Future<List<Place>> list() async {
    final res = await _client.photos.listPlaces(pb.ListPlacesRequest());
    return res.places.map(_place).toList();
  }
}
