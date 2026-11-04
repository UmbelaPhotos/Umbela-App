//
//  Generated code. Do not modify.
//  source: v1/photo.proto
//

import "package:connectrpc/connect.dart" as connect;

import "photo.pb.dart" as v1photo;

abstract final class PhotoService {
  /// Fully-qualified name of the PhotoService service.
  static const name = 'umbela.v1.PhotoService';

  static const getTimeline = connect.Spec(
    '/$name/GetTimeline',
    connect.StreamType.unary,
    v1photo.GetTimelineRequest.new,
    v1photo.GetTimelineResponse.new,
  );

  /// Photo count per month, newest first. Tiny; lets the client lay out the
  /// whole timeline and jump anywhere before loading a single photo.
  static const getTimelineBuckets = connect.Spec(
    '/$name/GetTimelineBuckets',
    connect.StreamType.unary,
    v1photo.GetTimelineBucketsRequest.new,
    v1photo.GetTimelineBucketsResponse.new,
  );

  static const streamThumbnail = connect.Spec(
    '/$name/StreamThumbnail',
    connect.StreamType.server,
    v1photo.GetThumbnailRequest.new,
    v1photo.Chunk.new,
  );

  static const streamFullImage = connect.Spec(
    '/$name/StreamFullImage',
    connect.StreamType.server,
    v1photo.GetFullImageRequest.new,
    v1photo.Chunk.new,
  );

  static const getPhotoDetails = connect.Spec(
    '/$name/GetPhotoDetails',
    connect.StreamType.unary,
    v1photo.GetPhotoDetailsRequest.new,
    v1photo.GetPhotoDetailsResponse.new,
  );

  /// Acciones sobre fotos (Pantalla 7 - Visor)
  static const toggleFavorite = connect.Spec(
    '/$name/ToggleFavorite',
    connect.StreamType.unary,
    v1photo.ToggleFavoriteRequest.new,
    v1photo.ToggleFavoriteResponse.new,
  );

  static const deletePhoto = connect.Spec(
    '/$name/DeletePhoto',
    connect.StreamType.unary,
    v1photo.DeletePhotoRequest.new,
    v1photo.DeletePhotoResponse.new,
  );

  static const addPhotoToAlbum = connect.Spec(
    '/$name/AddPhotoToAlbum',
    connect.StreamType.unary,
    v1photo.AddPhotoToAlbumRequest.new,
    v1photo.AddPhotoToAlbumResponse.new,
  );

  static const listPeople = connect.Spec(
    '/$name/ListPeople',
    connect.StreamType.unary,
    v1photo.ListPeopleRequest.new,
    v1photo.ListPeopleResponse.new,
  );

  static const labelPerson = connect.Spec(
    '/$name/LabelPerson',
    connect.StreamType.unary,
    v1photo.LabelPersonRequest.new,
    v1photo.LabelPersonResponse.new,
  );

  static const getPersonDetails = connect.Spec(
    '/$name/GetPersonDetails',
    connect.StreamType.unary,
    v1photo.GetPersonDetailsRequest.new,
    v1photo.GetPersonDetailsResponse.new,
  );

  static const setPersonCover = connect.Spec(
    '/$name/SetPersonCover',
    connect.StreamType.unary,
    v1photo.SetPersonCoverRequest.new,
    v1photo.SetPersonCoverResponse.new,
  );

  static const listAlbums = connect.Spec(
    '/$name/ListAlbums',
    connect.StreamType.unary,
    v1photo.ListAlbumsRequest.new,
    v1photo.ListAlbumsResponse.new,
  );

  static const createAlbum = connect.Spec(
    '/$name/CreateAlbum',
    connect.StreamType.unary,
    v1photo.CreateAlbumRequest.new,
    v1photo.CreateAlbumResponse.new,
  );

  static const setAlbumCover = connect.Spec(
    '/$name/SetAlbumCover',
    connect.StreamType.unary,
    v1photo.SetAlbumCoverRequest.new,
    v1photo.SetAlbumCoverResponse.new,
  );

  static const listPlaces = connect.Spec(
    '/$name/ListPlaces',
    connect.StreamType.unary,
    v1photo.ListPlacesRequest.new,
    v1photo.ListPlacesResponse.new,
  );
}
