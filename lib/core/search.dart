import 'data/models.dart';

const _months = [
  'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', //
  'septiembre', 'octubre', 'noviembre', 'diciembre',
];

const _accents = {
  'á': 'a', 'é': 'e', 'í': 'i', 'ó': 'o', 'ú': 'u', 'ü': 'u', 'ñ': 'n', //
};

String _norm(String s) {
  final b = StringBuffer();
  for (final c in s.toLowerCase().split('')) {
    b.write(_accents[c] ?? c);
  }
  return b.toString();
}

List<String> _words(String s) =>
    _norm(s).split(RegExp(r'[^a-z0-9]+')).where((w) => w.isNotEmpty).toList();

/// Every query word must be the start of some word in [text].
bool _matches(String text, List<String> query) {
  final words = _words(text);
  return query.every((q) => words.any((w) => w.startsWith(q)));
}

/// Words a photo can be found by: "14 septiembre sep 2026 hoy".
String photoDateText(DateTime d, {DateTime? now}) {
  now ??= DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final diff = today.difference(DateTime(d.year, d.month, d.day)).inDays;
  final month = _months[d.month - 1];
  return [
    d.day,
    month,
    month.substring(0, 3),
    d.year,
    if (diff == 0) 'hoy',
    if (diff == 1) 'ayer',
  ].join(' ');
}

class SearchResults {
  const SearchResults({
    this.people = const [],
    this.albums = const [],
    this.places = const [],
    this.photos = const [],
  });

  final List<Person> people;
  final List<Album> albums;
  final List<Place> places;
  final List<Photo> photos;

  bool get isEmpty =>
      people.isEmpty && albums.isEmpty && places.isEmpty && photos.isEmpty;
}

/// Searches people, albums, places and photo dates. [personLabel] gives the
/// text shown for a person (anonymous faces have no name).
SearchResults search(
  String query, {
  required List<Person> people,
  required List<Album> albums,
  required List<Place> places,
  required List<Photo> photos,
  required String Function(Person) personLabel,
  DateTime? now,
}) {
  final q = _words(query);
  if (q.isEmpty) return const SearchResults();
  return SearchResults(
    people: people.where((p) => _matches(personLabel(p), q)).toList(),
    albums: albums.where((a) => _matches(a.name, q)).toList(),
    places: places.where((p) => _matches(p.name, q)).toList(),
    photos: photos
        .where((p) => _matches(photoDateText(p.takenAt, now: now), q))
        .toList(),
  );
}
