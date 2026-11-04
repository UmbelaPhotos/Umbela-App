// This is a generated file - do not edit.
//
// Generated from v1/photo.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'photo.pb.dart' as $0;
import 'photo.pbjson.dart';

export 'photo.pb.dart';

abstract class PhotoServiceBase extends $pb.GeneratedService {
  $async.Future<$0.GetTimelineResponse> getTimeline(
      $pb.ServerContext ctx, $0.GetTimelineRequest request);
  $async.Future<$0.GetTimelineBucketsResponse> getTimelineBuckets(
      $pb.ServerContext ctx, $0.GetTimelineBucketsRequest request);
  $async.Future<$0.Chunk> streamThumbnail(
      $pb.ServerContext ctx, $0.GetThumbnailRequest request);
  $async.Future<$0.Chunk> streamFullImage(
      $pb.ServerContext ctx, $0.GetFullImageRequest request);
  $async.Future<$0.GetPhotoDetailsResponse> getPhotoDetails(
      $pb.ServerContext ctx, $0.GetPhotoDetailsRequest request);
  $async.Future<$0.ToggleFavoriteResponse> toggleFavorite(
      $pb.ServerContext ctx, $0.ToggleFavoriteRequest request);
  $async.Future<$0.DeletePhotoResponse> deletePhoto(
      $pb.ServerContext ctx, $0.DeletePhotoRequest request);
  $async.Future<$0.AddPhotoToAlbumResponse> addPhotoToAlbum(
      $pb.ServerContext ctx, $0.AddPhotoToAlbumRequest request);
  $async.Future<$0.ListPeopleResponse> listPeople(
      $pb.ServerContext ctx, $0.ListPeopleRequest request);
  $async.Future<$0.LabelPersonResponse> labelPerson(
      $pb.ServerContext ctx, $0.LabelPersonRequest request);
  $async.Future<$0.GetPersonDetailsResponse> getPersonDetails(
      $pb.ServerContext ctx, $0.GetPersonDetailsRequest request);
  $async.Future<$0.SetPersonCoverResponse> setPersonCover(
      $pb.ServerContext ctx, $0.SetPersonCoverRequest request);
  $async.Future<$0.ListAlbumsResponse> listAlbums(
      $pb.ServerContext ctx, $0.ListAlbumsRequest request);
  $async.Future<$0.CreateAlbumResponse> createAlbum(
      $pb.ServerContext ctx, $0.CreateAlbumRequest request);
  $async.Future<$0.SetAlbumCoverResponse> setAlbumCover(
      $pb.ServerContext ctx, $0.SetAlbumCoverRequest request);
  $async.Future<$0.ListPlacesResponse> listPlaces(
      $pb.ServerContext ctx, $0.ListPlacesRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetTimeline':
        return $0.GetTimelineRequest();
      case 'GetTimelineBuckets':
        return $0.GetTimelineBucketsRequest();
      case 'StreamThumbnail':
        return $0.GetThumbnailRequest();
      case 'StreamFullImage':
        return $0.GetFullImageRequest();
      case 'GetPhotoDetails':
        return $0.GetPhotoDetailsRequest();
      case 'ToggleFavorite':
        return $0.ToggleFavoriteRequest();
      case 'DeletePhoto':
        return $0.DeletePhotoRequest();
      case 'AddPhotoToAlbum':
        return $0.AddPhotoToAlbumRequest();
      case 'ListPeople':
        return $0.ListPeopleRequest();
      case 'LabelPerson':
        return $0.LabelPersonRequest();
      case 'GetPersonDetails':
        return $0.GetPersonDetailsRequest();
      case 'SetPersonCover':
        return $0.SetPersonCoverRequest();
      case 'ListAlbums':
        return $0.ListAlbumsRequest();
      case 'CreateAlbum':
        return $0.CreateAlbumRequest();
      case 'SetAlbumCover':
        return $0.SetAlbumCoverRequest();
      case 'ListPlaces':
        return $0.ListPlacesRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetTimeline':
        return getTimeline(ctx, request as $0.GetTimelineRequest);
      case 'GetTimelineBuckets':
        return getTimelineBuckets(ctx, request as $0.GetTimelineBucketsRequest);
      case 'StreamThumbnail':
        return streamThumbnail(ctx, request as $0.GetThumbnailRequest);
      case 'StreamFullImage':
        return streamFullImage(ctx, request as $0.GetFullImageRequest);
      case 'GetPhotoDetails':
        return getPhotoDetails(ctx, request as $0.GetPhotoDetailsRequest);
      case 'ToggleFavorite':
        return toggleFavorite(ctx, request as $0.ToggleFavoriteRequest);
      case 'DeletePhoto':
        return deletePhoto(ctx, request as $0.DeletePhotoRequest);
      case 'AddPhotoToAlbum':
        return addPhotoToAlbum(ctx, request as $0.AddPhotoToAlbumRequest);
      case 'ListPeople':
        return listPeople(ctx, request as $0.ListPeopleRequest);
      case 'LabelPerson':
        return labelPerson(ctx, request as $0.LabelPersonRequest);
      case 'GetPersonDetails':
        return getPersonDetails(ctx, request as $0.GetPersonDetailsRequest);
      case 'SetPersonCover':
        return setPersonCover(ctx, request as $0.SetPersonCoverRequest);
      case 'ListAlbums':
        return listAlbums(ctx, request as $0.ListAlbumsRequest);
      case 'CreateAlbum':
        return createAlbum(ctx, request as $0.CreateAlbumRequest);
      case 'SetAlbumCover':
        return setAlbumCover(ctx, request as $0.SetAlbumCoverRequest);
      case 'ListPlaces':
        return listPlaces(ctx, request as $0.ListPlacesRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => PhotoServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => PhotoServiceBase$messageJson;
}
