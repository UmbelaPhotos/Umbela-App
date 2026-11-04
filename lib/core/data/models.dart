class Photo {
  const Photo({
    required this.id,
    required this.takenAt,
    this.isVideo = false,
    this.tall = false,
    this.blurhash = '',
    this.aspect = 0,
  });

  final String id;
  final DateTime takenAt;
  final bool isVideo;

  /// Tiny text placeholder shown until the thumbnail arrives. May be empty.
  final String blurhash;

  /// Masonry hint: tall cells span two rows.
  final bool tall;

  /// width / height, or 0 when unknown.
  final double aspect;

  /// Aspect used to lay the photo out; unknown ones follow [tall], and
  /// extreme panoramas are limited so a row never gets absurdly short.
  double get layoutAspect =>
      (aspect > 0 ? aspect : (tall ? 0.75 : 1.33)).clamp(0.5, 2.2);
}

/// Photos taken in one calendar month (viewer's time zone). `from`..`to` is
/// the inclusive range to ask the server for exactly this month.
class TimelineBucket {
  const TimelineBucket({
    required this.year,
    required this.month,
    required this.count,
    required this.from,
    required this.to,
  });

  final int year;
  final int month;
  final int count;
  final DateTime from;
  final DateTime to;

  /// Unique and ordered: later months have bigger keys.
  int get key => year * 12 + month - 1;

  bool contains(DateTime t) => !t.isBefore(from) && !t.isAfter(to);
}

class Person {
  const Person({
    required this.id,
    required this.name,
    required this.photoCount,
    this.albumCount = 0,
    this.seed = 0,
    this.coverPhotoId = '',
  });

  final String id;

  /// Empty when the face has not been labelled yet.
  final String name;
  final int photoCount;
  final int albumCount;
  final int seed;

  /// Photo shown as the person's picture; empty when there is none.
  final String coverPhotoId;

  bool get isAnonymous => name.isEmpty;
}

class Album {
  const Album({
    required this.id,
    required this.name,
    required this.photoCount,
    this.encrypted = true,
    this.videoCover = false,
    this.coverPhotoId = '',
  });

  final String id;
  final String name;
  final int photoCount;
  final bool encrypted;
  final bool videoCover;

  /// Photo shown as the album's picture; empty when there is none.
  final String coverPhotoId;
}

class Place {
  const Place({
    required this.id,
    required this.name,
    required this.photoCount,
    this.latitude = 0,
    this.longitude = 0,
  });

  final String id;
  final String name;
  final int photoCount;
  final double latitude;
  final double longitude;
}

class FaceInPhoto {
  const FaceInPhoto({
    required this.personId,
    required this.name,
    required this.confidence,
    this.seed = 0,
  });

  final String personId;
  final String name;

  /// 0..1
  final double confidence;
  final int seed;
}

class PhotoDetails {
  const PhotoDetails({
    required this.photo,
    required this.uploader,
    required this.placeName,
    required this.iso,
    required this.aperture,
    required this.encryptedAtRest,
    required this.faces,
    this.favorite = false,
  });

  final Photo photo;
  final String uploader;
  final String placeName;
  final int iso;
  final double aperture;
  final bool encryptedAtRest;
  final bool favorite;
  final List<FaceInPhoto> faces;
}

class PersonDetails {
  const PersonDetails({
    required this.person,
    required this.albums,
    required this.places,
    required this.photos,
  });

  final Person person;
  final List<Album> albums;
  final List<Place> places;
  final List<Photo> photos;
}
