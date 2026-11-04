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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Chunk extends $pb.GeneratedMessage {
  factory Chunk({
    $core.List<$core.int>? data,
  }) {
    final result = Chunk._();
    if (data != null) result.data = data;
    return result;
  }

  Chunk._();

  factory Chunk.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Chunk()..mergeFromBuffer(data, registry);
  factory Chunk.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Chunk()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Chunk',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: Chunk.$_createMessage)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chunk clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chunk copyWith(void Function(Chunk) updates) =>
      super.copyWith((message) => updates(message as Chunk)) as Chunk;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Chunk() / Chunk.new instead')
  static Chunk create() => Chunk._();
  static $pb.GeneratedMessage $_createMessage() => Chunk._();
  @$core.override
  Chunk createEmptyInstance() => Chunk._();
  @$core.pragma('dart2js:noInline')
  static Chunk getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Chunk>(Chunk.$_createMessage);
  static Chunk? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => $_clearField(1);
}

class PhotoSummary extends $pb.GeneratedMessage {
  factory PhotoSummary({
    $core.String? id,
    $fixnum.Int64? takenAtUnix,
    $core.bool? isVideo,
    $core.String? blurhash,
    $core.int? width,
    $core.int? height,
    $core.bool? favorite,
  }) {
    final result = PhotoSummary._();
    if (id != null) result.id = id;
    if (takenAtUnix != null) result.takenAtUnix = takenAtUnix;
    if (isVideo != null) result.isVideo = isVideo;
    if (blurhash != null) result.blurhash = blurhash;
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    if (favorite != null) result.favorite = favorite;
    return result;
  }

  PhotoSummary._();

  factory PhotoSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PhotoSummary()..mergeFromBuffer(data, registry);
  factory PhotoSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PhotoSummary()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PhotoSummary',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: PhotoSummary.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aInt64(2, _omitFieldNames ? '' : 'takenAtUnix')
    ..aOB(3, _omitFieldNames ? '' : 'isVideo')
    ..aOS(4, _omitFieldNames ? '' : 'blurhash')
    ..aI(5, _omitFieldNames ? '' : 'width')
    ..aI(6, _omitFieldNames ? '' : 'height')
    ..aOB(7, _omitFieldNames ? '' : 'favorite')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhotoSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhotoSummary copyWith(void Function(PhotoSummary) updates) =>
      super.copyWith((message) => updates(message as PhotoSummary))
          as PhotoSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PhotoSummary() / PhotoSummary.new instead')
  static PhotoSummary create() => PhotoSummary._();
  static $pb.GeneratedMessage $_createMessage() => PhotoSummary._();
  @$core.override
  PhotoSummary createEmptyInstance() => PhotoSummary._();
  @$core.pragma('dart2js:noInline')
  static PhotoSummary getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PhotoSummary>(
          PhotoSummary.$_createMessage);
  static PhotoSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get takenAtUnix => $_getI64(1);
  @$pb.TagNumber(2)
  set takenAtUnix($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTakenAtUnix() => $_has(1);
  @$pb.TagNumber(2)
  void clearTakenAtUnix() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isVideo => $_getBF(2);
  @$pb.TagNumber(3)
  set isVideo($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsVideo() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsVideo() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get blurhash => $_getSZ(3);
  @$pb.TagNumber(4)
  set blurhash($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBlurhash() => $_has(3);
  @$pb.TagNumber(4)
  void clearBlurhash() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get width => $_getIZ(4);
  @$pb.TagNumber(5)
  set width($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasWidth() => $_has(4);
  @$pb.TagNumber(5)
  void clearWidth() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get height => $_getIZ(5);
  @$pb.TagNumber(6)
  set height($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHeight() => $_has(5);
  @$pb.TagNumber(6)
  void clearHeight() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get favorite => $_getBF(6);
  @$pb.TagNumber(7)
  set favorite($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFavorite() => $_has(6);
  @$pb.TagNumber(7)
  void clearFavorite() => $_clearField(7);
}

class GetTimelineRequest extends $pb.GeneratedMessage {
  factory GetTimelineRequest({
    $fixnum.Int64? fromUnix,
    $fixnum.Int64? toUnix,
    $core.String? personId,
    $core.String? albumId,
    $core.String? placeId,
    $core.int? pageSize,
    $core.String? cursor,
  }) {
    final result = GetTimelineRequest._();
    if (fromUnix != null) result.fromUnix = fromUnix;
    if (toUnix != null) result.toUnix = toUnix;
    if (personId != null) result.personId = personId;
    if (albumId != null) result.albumId = albumId;
    if (placeId != null) result.placeId = placeId;
    if (pageSize != null) result.pageSize = pageSize;
    if (cursor != null) result.cursor = cursor;
    return result;
  }

  GetTimelineRequest._();

  factory GetTimelineRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetTimelineRequest()..mergeFromBuffer(data, registry);
  factory GetTimelineRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetTimelineRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTimelineRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: GetTimelineRequest.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'fromUnix')
    ..aInt64(2, _omitFieldNames ? '' : 'toUnix')
    ..aOS(3, _omitFieldNames ? '' : 'personId')
    ..aOS(4, _omitFieldNames ? '' : 'albumId')
    ..aOS(5, _omitFieldNames ? '' : 'placeId')
    ..aI(6, _omitFieldNames ? '' : 'pageSize')
    ..aOS(7, _omitFieldNames ? '' : 'cursor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTimelineRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTimelineRequest copyWith(void Function(GetTimelineRequest) updates) =>
      super.copyWith((message) => updates(message as GetTimelineRequest))
          as GetTimelineRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetTimelineRequest() / GetTimelineRequest.new instead')
  static GetTimelineRequest create() => GetTimelineRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetTimelineRequest._();
  @$core.override
  GetTimelineRequest createEmptyInstance() => GetTimelineRequest._();
  @$core.pragma('dart2js:noInline')
  static GetTimelineRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTimelineRequest>(
          GetTimelineRequest.$_createMessage);
  static GetTimelineRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get fromUnix => $_getI64(0);
  @$pb.TagNumber(1)
  set fromUnix($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFromUnix() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromUnix() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get toUnix => $_getI64(1);
  @$pb.TagNumber(2)
  set toUnix($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToUnix() => $_has(1);
  @$pb.TagNumber(2)
  void clearToUnix() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get personId => $_getSZ(2);
  @$pb.TagNumber(3)
  set personId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPersonId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPersonId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get albumId => $_getSZ(3);
  @$pb.TagNumber(4)
  set albumId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAlbumId() => $_has(3);
  @$pb.TagNumber(4)
  void clearAlbumId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get placeId => $_getSZ(4);
  @$pb.TagNumber(5)
  set placeId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPlaceId() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlaceId() => $_clearField(5);

  /// Max photos per page; 0 means the server default. The server caps it.
  @$pb.TagNumber(6)
  $core.int get pageSize => $_getIZ(5);
  @$pb.TagNumber(6)
  set pageSize($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPageSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearPageSize() => $_clearField(6);

  /// Opaque; empty for the first page, else the previous next_cursor.
  @$pb.TagNumber(7)
  $core.String get cursor => $_getSZ(6);
  @$pb.TagNumber(7)
  set cursor($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCursor() => $_has(6);
  @$pb.TagNumber(7)
  void clearCursor() => $_clearField(7);
}

class GetTimelineResponse extends $pb.GeneratedMessage {
  factory GetTimelineResponse({
    $core.Iterable<PhotoSummary>? photos,
    $core.String? nextCursor,
  }) {
    final result = GetTimelineResponse._();
    if (photos != null) result.photos.addAll(photos);
    if (nextCursor != null) result.nextCursor = nextCursor;
    return result;
  }

  GetTimelineResponse._();

  factory GetTimelineResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetTimelineResponse()..mergeFromBuffer(data, registry);
  factory GetTimelineResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetTimelineResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTimelineResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: GetTimelineResponse.$_createMessage)
    ..pPM<PhotoSummary>(1, _omitFieldNames ? '' : 'photos',
        subBuilder: PhotoSummary.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextCursor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTimelineResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTimelineResponse copyWith(void Function(GetTimelineResponse) updates) =>
      super.copyWith((message) => updates(message as GetTimelineResponse))
          as GetTimelineResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetTimelineResponse() / GetTimelineResponse.new instead')
  static GetTimelineResponse create() => GetTimelineResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetTimelineResponse._();
  @$core.override
  GetTimelineResponse createEmptyInstance() => GetTimelineResponse._();
  @$core.pragma('dart2js:noInline')
  static GetTimelineResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTimelineResponse>(
          GetTimelineResponse.$_createMessage);
  static GetTimelineResponse? _defaultInstance;

  /// Newest first, ties broken by id, so pages never skip or repeat a photo.
  @$pb.TagNumber(1)
  $pb.PbList<PhotoSummary> get photos => $_getList(0);

  /// Empty when there are no more photos in the requested range.
  @$pb.TagNumber(2)
  $core.String get nextCursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextCursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextCursor() => $_clearField(2);
}

class GetTimelineBucketsRequest extends $pb.GeneratedMessage {
  factory GetTimelineBucketsRequest({
    $core.int? tzOffsetSeconds,
  }) {
    final result = GetTimelineBucketsRequest._();
    if (tzOffsetSeconds != null) result.tzOffsetSeconds = tzOffsetSeconds;
    return result;
  }

  GetTimelineBucketsRequest._();

  factory GetTimelineBucketsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetTimelineBucketsRequest()..mergeFromBuffer(data, registry);
  factory GetTimelineBucketsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetTimelineBucketsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTimelineBucketsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: GetTimelineBucketsRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'tzOffsetSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTimelineBucketsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTimelineBucketsRequest copyWith(
          void Function(GetTimelineBucketsRequest) updates) =>
      super.copyWith((message) => updates(message as GetTimelineBucketsRequest))
          as GetTimelineBucketsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetTimelineBucketsRequest() / GetTimelineBucketsRequest.new instead')
  static GetTimelineBucketsRequest create() => GetTimelineBucketsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetTimelineBucketsRequest._();
  @$core.override
  GetTimelineBucketsRequest createEmptyInstance() =>
      GetTimelineBucketsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetTimelineBucketsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTimelineBucketsRequest>(
          GetTimelineBucketsRequest.$_createMessage);
  static GetTimelineBucketsRequest? _defaultInstance;

  /// Viewer's UTC offset, so a photo taken at 23:30 local lands in its local
  /// month.
  @$pb.TagNumber(1)
  $core.int get tzOffsetSeconds => $_getIZ(0);
  @$pb.TagNumber(1)
  set tzOffsetSeconds($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTzOffsetSeconds() => $_has(0);
  @$pb.TagNumber(1)
  void clearTzOffsetSeconds() => $_clearField(1);
}

class TimelineBucket extends $pb.GeneratedMessage {
  factory TimelineBucket({
    $core.int? year,
    $core.int? month,
    $core.int? count,
    $fixnum.Int64? fromUnix,
    $fixnum.Int64? toUnix,
  }) {
    final result = TimelineBucket._();
    if (year != null) result.year = year;
    if (month != null) result.month = month;
    if (count != null) result.count = count;
    if (fromUnix != null) result.fromUnix = fromUnix;
    if (toUnix != null) result.toUnix = toUnix;
    return result;
  }

  TimelineBucket._();

  factory TimelineBucket.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TimelineBucket()..mergeFromBuffer(data, registry);
  factory TimelineBucket.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TimelineBucket()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TimelineBucket',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: TimelineBucket.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'year')
    ..aI(2, _omitFieldNames ? '' : 'month')
    ..aI(3, _omitFieldNames ? '' : 'count')
    ..aInt64(4, _omitFieldNames ? '' : 'fromUnix')
    ..aInt64(5, _omitFieldNames ? '' : 'toUnix')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TimelineBucket clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TimelineBucket copyWith(void Function(TimelineBucket) updates) =>
      super.copyWith((message) => updates(message as TimelineBucket))
          as TimelineBucket;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TimelineBucket() / TimelineBucket.new instead')
  static TimelineBucket create() => TimelineBucket._();
  static $pb.GeneratedMessage $_createMessage() => TimelineBucket._();
  @$core.override
  TimelineBucket createEmptyInstance() => TimelineBucket._();
  @$core.pragma('dart2js:noInline')
  static TimelineBucket getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TimelineBucket>(
          TimelineBucket.$_createMessage);
  static TimelineBucket? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get year => $_getIZ(0);
  @$pb.TagNumber(1)
  set year($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasYear() => $_has(0);
  @$pb.TagNumber(1)
  void clearYear() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get month => $_getIZ(1);
  @$pb.TagNumber(2)
  set month($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMonth() => $_has(1);
  @$pb.TagNumber(2)
  void clearMonth() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get count => $_getIZ(2);
  @$pb.TagNumber(3)
  set count($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearCount() => $_clearField(3);

  /// Inclusive range to pass as from_unix / to_unix to GetTimeline.
  @$pb.TagNumber(4)
  $fixnum.Int64 get fromUnix => $_getI64(3);
  @$pb.TagNumber(4)
  set fromUnix($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFromUnix() => $_has(3);
  @$pb.TagNumber(4)
  void clearFromUnix() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get toUnix => $_getI64(4);
  @$pb.TagNumber(5)
  set toUnix($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasToUnix() => $_has(4);
  @$pb.TagNumber(5)
  void clearToUnix() => $_clearField(5);
}

class GetTimelineBucketsResponse extends $pb.GeneratedMessage {
  factory GetTimelineBucketsResponse({
    $core.Iterable<TimelineBucket>? buckets,
  }) {
    final result = GetTimelineBucketsResponse._();
    if (buckets != null) result.buckets.addAll(buckets);
    return result;
  }

  GetTimelineBucketsResponse._();

  factory GetTimelineBucketsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetTimelineBucketsResponse()..mergeFromBuffer(data, registry);
  factory GetTimelineBucketsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetTimelineBucketsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTimelineBucketsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: GetTimelineBucketsResponse.$_createMessage)
    ..pPM<TimelineBucket>(1, _omitFieldNames ? '' : 'buckets',
        subBuilder: TimelineBucket.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTimelineBucketsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTimelineBucketsResponse copyWith(
          void Function(GetTimelineBucketsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetTimelineBucketsResponse))
          as GetTimelineBucketsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetTimelineBucketsResponse() / GetTimelineBucketsResponse.new instead')
  static GetTimelineBucketsResponse create() => GetTimelineBucketsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetTimelineBucketsResponse._();
  @$core.override
  GetTimelineBucketsResponse createEmptyInstance() =>
      GetTimelineBucketsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetTimelineBucketsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTimelineBucketsResponse>(
          GetTimelineBucketsResponse.$_createMessage);
  static GetTimelineBucketsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TimelineBucket> get buckets => $_getList(0);
}

class GetThumbnailRequest extends $pb.GeneratedMessage {
  factory GetThumbnailRequest({
    $core.String? photoId,
    $core.int? maxSize,
  }) {
    final result = GetThumbnailRequest._();
    if (photoId != null) result.photoId = photoId;
    if (maxSize != null) result.maxSize = maxSize;
    return result;
  }

  GetThumbnailRequest._();

  factory GetThumbnailRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetThumbnailRequest()..mergeFromBuffer(data, registry);
  factory GetThumbnailRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetThumbnailRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetThumbnailRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: GetThumbnailRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'photoId')
    ..aI(2, _omitFieldNames ? '' : 'maxSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetThumbnailRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetThumbnailRequest copyWith(void Function(GetThumbnailRequest) updates) =>
      super.copyWith((message) => updates(message as GetThumbnailRequest))
          as GetThumbnailRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetThumbnailRequest() / GetThumbnailRequest.new instead')
  static GetThumbnailRequest create() => GetThumbnailRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetThumbnailRequest._();
  @$core.override
  GetThumbnailRequest createEmptyInstance() => GetThumbnailRequest._();
  @$core.pragma('dart2js:noInline')
  static GetThumbnailRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetThumbnailRequest>(
          GetThumbnailRequest.$_createMessage);
  static GetThumbnailRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get photoId => $_getSZ(0);
  @$pb.TagNumber(1)
  set photoId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPhotoId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhotoId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get maxSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set maxSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxSize() => $_clearField(2);
}

class GetFullImageRequest extends $pb.GeneratedMessage {
  factory GetFullImageRequest({
    $core.String? photoId,
  }) {
    final result = GetFullImageRequest._();
    if (photoId != null) result.photoId = photoId;
    return result;
  }

  GetFullImageRequest._();

  factory GetFullImageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetFullImageRequest()..mergeFromBuffer(data, registry);
  factory GetFullImageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetFullImageRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFullImageRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: GetFullImageRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'photoId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFullImageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFullImageRequest copyWith(void Function(GetFullImageRequest) updates) =>
      super.copyWith((message) => updates(message as GetFullImageRequest))
          as GetFullImageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetFullImageRequest() / GetFullImageRequest.new instead')
  static GetFullImageRequest create() => GetFullImageRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetFullImageRequest._();
  @$core.override
  GetFullImageRequest createEmptyInstance() => GetFullImageRequest._();
  @$core.pragma('dart2js:noInline')
  static GetFullImageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFullImageRequest>(
          GetFullImageRequest.$_createMessage);
  static GetFullImageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get photoId => $_getSZ(0);
  @$pb.TagNumber(1)
  set photoId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPhotoId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhotoId() => $_clearField(1);
}

class FaceInPhoto extends $pb.GeneratedMessage {
  factory FaceInPhoto({
    $core.String? personId,
    $core.String? name,
    $core.double? confidence,
  }) {
    final result = FaceInPhoto._();
    if (personId != null) result.personId = personId;
    if (name != null) result.name = name;
    if (confidence != null) result.confidence = confidence;
    return result;
  }

  FaceInPhoto._();

  factory FaceInPhoto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FaceInPhoto()..mergeFromBuffer(data, registry);
  factory FaceInPhoto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FaceInPhoto()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FaceInPhoto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: FaceInPhoto.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'personId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aD(3, _omitFieldNames ? '' : 'confidence', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FaceInPhoto clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FaceInPhoto copyWith(void Function(FaceInPhoto) updates) =>
      super.copyWith((message) => updates(message as FaceInPhoto))
          as FaceInPhoto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FaceInPhoto() / FaceInPhoto.new instead')
  static FaceInPhoto create() => FaceInPhoto._();
  static $pb.GeneratedMessage $_createMessage() => FaceInPhoto._();
  @$core.override
  FaceInPhoto createEmptyInstance() => FaceInPhoto._();
  @$core.pragma('dart2js:noInline')
  static FaceInPhoto getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FaceInPhoto>(
          FaceInPhoto.$_createMessage);
  static FaceInPhoto? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get personId => $_getSZ(0);
  @$pb.TagNumber(1)
  set personId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPersonId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPersonId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get confidence => $_getN(2);
  @$pb.TagNumber(3)
  set confidence($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConfidence() => $_has(2);
  @$pb.TagNumber(3)
  void clearConfidence() => $_clearField(3);
}

class PhotoDetails extends $pb.GeneratedMessage {
  factory PhotoDetails({
    PhotoSummary? summary,
    $core.String? uploader,
    $core.String? placeName,
    $core.double? latitude,
    $core.double? longitude,
    $core.int? iso,
    $core.double? aperture,
    $core.bool? encryptedAtRest,
    $core.bool? favorite,
    $core.Iterable<FaceInPhoto>? faces,
  }) {
    final result = PhotoDetails._();
    if (summary != null) result.summary = summary;
    if (uploader != null) result.uploader = uploader;
    if (placeName != null) result.placeName = placeName;
    if (latitude != null) result.latitude = latitude;
    if (longitude != null) result.longitude = longitude;
    if (iso != null) result.iso = iso;
    if (aperture != null) result.aperture = aperture;
    if (encryptedAtRest != null) result.encryptedAtRest = encryptedAtRest;
    if (favorite != null) result.favorite = favorite;
    if (faces != null) result.faces.addAll(faces);
    return result;
  }

  PhotoDetails._();

  factory PhotoDetails.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PhotoDetails()..mergeFromBuffer(data, registry);
  factory PhotoDetails.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PhotoDetails()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PhotoDetails',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: PhotoDetails.$_createMessage)
    ..aOM<PhotoSummary>(1, _omitFieldNames ? '' : 'summary',
        subBuilder: PhotoSummary.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'uploader')
    ..aOS(3, _omitFieldNames ? '' : 'placeName')
    ..aD(4, _omitFieldNames ? '' : 'latitude')
    ..aD(5, _omitFieldNames ? '' : 'longitude')
    ..aI(6, _omitFieldNames ? '' : 'iso')
    ..aD(7, _omitFieldNames ? '' : 'aperture', fieldType: $pb.PbFieldType.OF)
    ..aOB(8, _omitFieldNames ? '' : 'encryptedAtRest')
    ..aOB(9, _omitFieldNames ? '' : 'favorite')
    ..pPM<FaceInPhoto>(10, _omitFieldNames ? '' : 'faces',
        subBuilder: FaceInPhoto.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhotoDetails clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhotoDetails copyWith(void Function(PhotoDetails) updates) =>
      super.copyWith((message) => updates(message as PhotoDetails))
          as PhotoDetails;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PhotoDetails() / PhotoDetails.new instead')
  static PhotoDetails create() => PhotoDetails._();
  static $pb.GeneratedMessage $_createMessage() => PhotoDetails._();
  @$core.override
  PhotoDetails createEmptyInstance() => PhotoDetails._();
  @$core.pragma('dart2js:noInline')
  static PhotoDetails getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PhotoDetails>(
          PhotoDetails.$_createMessage);
  static PhotoDetails? _defaultInstance;

  @$pb.TagNumber(1)
  PhotoSummary get summary => $_getN(0);
  @$pb.TagNumber(1)
  set summary(PhotoSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);
  @$pb.TagNumber(1)
  PhotoSummary ensureSummary() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get uploader => $_getSZ(1);
  @$pb.TagNumber(2)
  set uploader($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUploader() => $_has(1);
  @$pb.TagNumber(2)
  void clearUploader() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get placeName => $_getSZ(2);
  @$pb.TagNumber(3)
  set placeName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlaceName() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlaceName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get latitude => $_getN(3);
  @$pb.TagNumber(4)
  set latitude($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLatitude() => $_has(3);
  @$pb.TagNumber(4)
  void clearLatitude() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get longitude => $_getN(4);
  @$pb.TagNumber(5)
  set longitude($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLongitude() => $_has(4);
  @$pb.TagNumber(5)
  void clearLongitude() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get iso => $_getIZ(5);
  @$pb.TagNumber(6)
  set iso($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIso() => $_has(5);
  @$pb.TagNumber(6)
  void clearIso() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get aperture => $_getN(6);
  @$pb.TagNumber(7)
  set aperture($core.double value) => $_setFloat(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAperture() => $_has(6);
  @$pb.TagNumber(7)
  void clearAperture() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get encryptedAtRest => $_getBF(7);
  @$pb.TagNumber(8)
  set encryptedAtRest($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEncryptedAtRest() => $_has(7);
  @$pb.TagNumber(8)
  void clearEncryptedAtRest() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get favorite => $_getBF(8);
  @$pb.TagNumber(9)
  set favorite($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasFavorite() => $_has(8);
  @$pb.TagNumber(9)
  void clearFavorite() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<FaceInPhoto> get faces => $_getList(9);
}

class GetPhotoDetailsRequest extends $pb.GeneratedMessage {
  factory GetPhotoDetailsRequest({
    $core.String? photoId,
  }) {
    final result = GetPhotoDetailsRequest._();
    if (photoId != null) result.photoId = photoId;
    return result;
  }

  GetPhotoDetailsRequest._();

  factory GetPhotoDetailsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPhotoDetailsRequest()..mergeFromBuffer(data, registry);
  factory GetPhotoDetailsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPhotoDetailsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPhotoDetailsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: GetPhotoDetailsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'photoId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPhotoDetailsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPhotoDetailsRequest copyWith(
          void Function(GetPhotoDetailsRequest) updates) =>
      super.copyWith((message) => updates(message as GetPhotoDetailsRequest))
          as GetPhotoDetailsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPhotoDetailsRequest() / GetPhotoDetailsRequest.new instead')
  static GetPhotoDetailsRequest create() => GetPhotoDetailsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetPhotoDetailsRequest._();
  @$core.override
  GetPhotoDetailsRequest createEmptyInstance() => GetPhotoDetailsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPhotoDetailsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPhotoDetailsRequest>(
          GetPhotoDetailsRequest.$_createMessage);
  static GetPhotoDetailsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get photoId => $_getSZ(0);
  @$pb.TagNumber(1)
  set photoId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPhotoId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhotoId() => $_clearField(1);
}

class GetPhotoDetailsResponse extends $pb.GeneratedMessage {
  factory GetPhotoDetailsResponse({
    PhotoDetails? photo,
  }) {
    final result = GetPhotoDetailsResponse._();
    if (photo != null) result.photo = photo;
    return result;
  }

  GetPhotoDetailsResponse._();

  factory GetPhotoDetailsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPhotoDetailsResponse()..mergeFromBuffer(data, registry);
  factory GetPhotoDetailsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPhotoDetailsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPhotoDetailsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: GetPhotoDetailsResponse.$_createMessage)
    ..aOM<PhotoDetails>(1, _omitFieldNames ? '' : 'photo',
        subBuilder: PhotoDetails.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPhotoDetailsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPhotoDetailsResponse copyWith(
          void Function(GetPhotoDetailsResponse) updates) =>
      super.copyWith((message) => updates(message as GetPhotoDetailsResponse))
          as GetPhotoDetailsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPhotoDetailsResponse() / GetPhotoDetailsResponse.new instead')
  static GetPhotoDetailsResponse create() => GetPhotoDetailsResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetPhotoDetailsResponse._();
  @$core.override
  GetPhotoDetailsResponse createEmptyInstance() => GetPhotoDetailsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetPhotoDetailsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPhotoDetailsResponse>(
          GetPhotoDetailsResponse.$_createMessage);
  static GetPhotoDetailsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PhotoDetails get photo => $_getN(0);
  @$pb.TagNumber(1)
  set photo(PhotoDetails value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPhoto() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhoto() => $_clearField(1);
  @$pb.TagNumber(1)
  PhotoDetails ensurePhoto() => $_ensure(0);
}

class ToggleFavoriteRequest extends $pb.GeneratedMessage {
  factory ToggleFavoriteRequest({
    $core.String? photoId,
  }) {
    final result = ToggleFavoriteRequest._();
    if (photoId != null) result.photoId = photoId;
    return result;
  }

  ToggleFavoriteRequest._();

  factory ToggleFavoriteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ToggleFavoriteRequest()..mergeFromBuffer(data, registry);
  factory ToggleFavoriteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ToggleFavoriteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToggleFavoriteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: ToggleFavoriteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'photoId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleFavoriteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleFavoriteRequest copyWith(
          void Function(ToggleFavoriteRequest) updates) =>
      super.copyWith((message) => updates(message as ToggleFavoriteRequest))
          as ToggleFavoriteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ToggleFavoriteRequest() / ToggleFavoriteRequest.new instead')
  static ToggleFavoriteRequest create() => ToggleFavoriteRequest._();
  static $pb.GeneratedMessage $_createMessage() => ToggleFavoriteRequest._();
  @$core.override
  ToggleFavoriteRequest createEmptyInstance() => ToggleFavoriteRequest._();
  @$core.pragma('dart2js:noInline')
  static ToggleFavoriteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToggleFavoriteRequest>(
          ToggleFavoriteRequest.$_createMessage);
  static ToggleFavoriteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get photoId => $_getSZ(0);
  @$pb.TagNumber(1)
  set photoId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPhotoId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhotoId() => $_clearField(1);
}

class ToggleFavoriteResponse extends $pb.GeneratedMessage {
  factory ToggleFavoriteResponse({
    $core.bool? isFavorite,
  }) {
    final result = ToggleFavoriteResponse._();
    if (isFavorite != null) result.isFavorite = isFavorite;
    return result;
  }

  ToggleFavoriteResponse._();

  factory ToggleFavoriteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ToggleFavoriteResponse()..mergeFromBuffer(data, registry);
  factory ToggleFavoriteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ToggleFavoriteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToggleFavoriteResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: ToggleFavoriteResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'isFavorite')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleFavoriteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleFavoriteResponse copyWith(
          void Function(ToggleFavoriteResponse) updates) =>
      super.copyWith((message) => updates(message as ToggleFavoriteResponse))
          as ToggleFavoriteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ToggleFavoriteResponse() / ToggleFavoriteResponse.new instead')
  static ToggleFavoriteResponse create() => ToggleFavoriteResponse._();
  static $pb.GeneratedMessage $_createMessage() => ToggleFavoriteResponse._();
  @$core.override
  ToggleFavoriteResponse createEmptyInstance() => ToggleFavoriteResponse._();
  @$core.pragma('dart2js:noInline')
  static ToggleFavoriteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToggleFavoriteResponse>(
          ToggleFavoriteResponse.$_createMessage);
  static ToggleFavoriteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isFavorite => $_getBF(0);
  @$pb.TagNumber(1)
  set isFavorite($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsFavorite() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsFavorite() => $_clearField(1);
}

class DeletePhotoRequest extends $pb.GeneratedMessage {
  factory DeletePhotoRequest({
    $core.String? photoId,
  }) {
    final result = DeletePhotoRequest._();
    if (photoId != null) result.photoId = photoId;
    return result;
  }

  DeletePhotoRequest._();

  factory DeletePhotoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeletePhotoRequest()..mergeFromBuffer(data, registry);
  factory DeletePhotoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeletePhotoRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeletePhotoRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: DeletePhotoRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'photoId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeletePhotoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeletePhotoRequest copyWith(void Function(DeletePhotoRequest) updates) =>
      super.copyWith((message) => updates(message as DeletePhotoRequest))
          as DeletePhotoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DeletePhotoRequest() / DeletePhotoRequest.new instead')
  static DeletePhotoRequest create() => DeletePhotoRequest._();
  static $pb.GeneratedMessage $_createMessage() => DeletePhotoRequest._();
  @$core.override
  DeletePhotoRequest createEmptyInstance() => DeletePhotoRequest._();
  @$core.pragma('dart2js:noInline')
  static DeletePhotoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeletePhotoRequest>(
          DeletePhotoRequest.$_createMessage);
  static DeletePhotoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get photoId => $_getSZ(0);
  @$pb.TagNumber(1)
  set photoId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPhotoId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhotoId() => $_clearField(1);
}

class DeletePhotoResponse extends $pb.GeneratedMessage {
  factory DeletePhotoResponse({
    $core.bool? success,
  }) {
    final result = DeletePhotoResponse._();
    if (success != null) result.success = success;
    return result;
  }

  DeletePhotoResponse._();

  factory DeletePhotoResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeletePhotoResponse()..mergeFromBuffer(data, registry);
  factory DeletePhotoResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeletePhotoResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeletePhotoResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: DeletePhotoResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeletePhotoResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeletePhotoResponse copyWith(void Function(DeletePhotoResponse) updates) =>
      super.copyWith((message) => updates(message as DeletePhotoResponse))
          as DeletePhotoResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use DeletePhotoResponse() / DeletePhotoResponse.new instead')
  static DeletePhotoResponse create() => DeletePhotoResponse._();
  static $pb.GeneratedMessage $_createMessage() => DeletePhotoResponse._();
  @$core.override
  DeletePhotoResponse createEmptyInstance() => DeletePhotoResponse._();
  @$core.pragma('dart2js:noInline')
  static DeletePhotoResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeletePhotoResponse>(
          DeletePhotoResponse.$_createMessage);
  static DeletePhotoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class AddPhotoToAlbumRequest extends $pb.GeneratedMessage {
  factory AddPhotoToAlbumRequest({
    $core.String? photoId,
    $core.String? albumId,
  }) {
    final result = AddPhotoToAlbumRequest._();
    if (photoId != null) result.photoId = photoId;
    if (albumId != null) result.albumId = albumId;
    return result;
  }

  AddPhotoToAlbumRequest._();

  factory AddPhotoToAlbumRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddPhotoToAlbumRequest()..mergeFromBuffer(data, registry);
  factory AddPhotoToAlbumRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddPhotoToAlbumRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddPhotoToAlbumRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: AddPhotoToAlbumRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'photoId')
    ..aOS(2, _omitFieldNames ? '' : 'albumId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddPhotoToAlbumRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddPhotoToAlbumRequest copyWith(
          void Function(AddPhotoToAlbumRequest) updates) =>
      super.copyWith((message) => updates(message as AddPhotoToAlbumRequest))
          as AddPhotoToAlbumRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AddPhotoToAlbumRequest() / AddPhotoToAlbumRequest.new instead')
  static AddPhotoToAlbumRequest create() => AddPhotoToAlbumRequest._();
  static $pb.GeneratedMessage $_createMessage() => AddPhotoToAlbumRequest._();
  @$core.override
  AddPhotoToAlbumRequest createEmptyInstance() => AddPhotoToAlbumRequest._();
  @$core.pragma('dart2js:noInline')
  static AddPhotoToAlbumRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddPhotoToAlbumRequest>(
          AddPhotoToAlbumRequest.$_createMessage);
  static AddPhotoToAlbumRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get photoId => $_getSZ(0);
  @$pb.TagNumber(1)
  set photoId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPhotoId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhotoId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get albumId => $_getSZ(1);
  @$pb.TagNumber(2)
  set albumId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAlbumId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlbumId() => $_clearField(2);
}

class AddPhotoToAlbumResponse extends $pb.GeneratedMessage {
  factory AddPhotoToAlbumResponse({
    $core.bool? success,
  }) {
    final result = AddPhotoToAlbumResponse._();
    if (success != null) result.success = success;
    return result;
  }

  AddPhotoToAlbumResponse._();

  factory AddPhotoToAlbumResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddPhotoToAlbumResponse()..mergeFromBuffer(data, registry);
  factory AddPhotoToAlbumResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddPhotoToAlbumResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddPhotoToAlbumResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: AddPhotoToAlbumResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddPhotoToAlbumResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddPhotoToAlbumResponse copyWith(
          void Function(AddPhotoToAlbumResponse) updates) =>
      super.copyWith((message) => updates(message as AddPhotoToAlbumResponse))
          as AddPhotoToAlbumResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AddPhotoToAlbumResponse() / AddPhotoToAlbumResponse.new instead')
  static AddPhotoToAlbumResponse create() => AddPhotoToAlbumResponse._();
  static $pb.GeneratedMessage $_createMessage() => AddPhotoToAlbumResponse._();
  @$core.override
  AddPhotoToAlbumResponse createEmptyInstance() => AddPhotoToAlbumResponse._();
  @$core.pragma('dart2js:noInline')
  static AddPhotoToAlbumResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddPhotoToAlbumResponse>(
          AddPhotoToAlbumResponse.$_createMessage);
  static AddPhotoToAlbumResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class PersonSummary extends $pb.GeneratedMessage {
  factory PersonSummary({
    $core.String? id,
    $core.String? name,
    $core.int? photoCount,
    $core.String? coverPhotoId,
  }) {
    final result = PersonSummary._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (photoCount != null) result.photoCount = photoCount;
    if (coverPhotoId != null) result.coverPhotoId = coverPhotoId;
    return result;
  }

  PersonSummary._();

  factory PersonSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PersonSummary()..mergeFromBuffer(data, registry);
  factory PersonSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PersonSummary()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PersonSummary',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: PersonSummary.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aI(3, _omitFieldNames ? '' : 'photoCount')
    ..aOS(4, _omitFieldNames ? '' : 'coverPhotoId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PersonSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PersonSummary copyWith(void Function(PersonSummary) updates) =>
      super.copyWith((message) => updates(message as PersonSummary))
          as PersonSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PersonSummary() / PersonSummary.new instead')
  static PersonSummary create() => PersonSummary._();
  static $pb.GeneratedMessage $_createMessage() => PersonSummary._();
  @$core.override
  PersonSummary createEmptyInstance() => PersonSummary._();
  @$core.pragma('dart2js:noInline')
  static PersonSummary getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PersonSummary>(
          PersonSummary.$_createMessage);
  static PersonSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get photoCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set photoCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPhotoCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearPhotoCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get coverPhotoId => $_getSZ(3);
  @$pb.TagNumber(4)
  set coverPhotoId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCoverPhotoId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoverPhotoId() => $_clearField(4);
}

class ListPeopleRequest extends $pb.GeneratedMessage {
  factory ListPeopleRequest() => ListPeopleRequest._();

  ListPeopleRequest._();

  factory ListPeopleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPeopleRequest()..mergeFromBuffer(data, registry);
  factory ListPeopleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPeopleRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPeopleRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: ListPeopleRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPeopleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPeopleRequest copyWith(void Function(ListPeopleRequest) updates) =>
      super.copyWith((message) => updates(message as ListPeopleRequest))
          as ListPeopleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListPeopleRequest() / ListPeopleRequest.new instead')
  static ListPeopleRequest create() => ListPeopleRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListPeopleRequest._();
  @$core.override
  ListPeopleRequest createEmptyInstance() => ListPeopleRequest._();
  @$core.pragma('dart2js:noInline')
  static ListPeopleRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListPeopleRequest>(
          ListPeopleRequest.$_createMessage);
  static ListPeopleRequest? _defaultInstance;
}

class ListPeopleResponse extends $pb.GeneratedMessage {
  factory ListPeopleResponse({
    $core.Iterable<PersonSummary>? people,
  }) {
    final result = ListPeopleResponse._();
    if (people != null) result.people.addAll(people);
    return result;
  }

  ListPeopleResponse._();

  factory ListPeopleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPeopleResponse()..mergeFromBuffer(data, registry);
  factory ListPeopleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPeopleResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPeopleResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: ListPeopleResponse.$_createMessage)
    ..pPM<PersonSummary>(1, _omitFieldNames ? '' : 'people',
        subBuilder: PersonSummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPeopleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPeopleResponse copyWith(void Function(ListPeopleResponse) updates) =>
      super.copyWith((message) => updates(message as ListPeopleResponse))
          as ListPeopleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListPeopleResponse() / ListPeopleResponse.new instead')
  static ListPeopleResponse create() => ListPeopleResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListPeopleResponse._();
  @$core.override
  ListPeopleResponse createEmptyInstance() => ListPeopleResponse._();
  @$core.pragma('dart2js:noInline')
  static ListPeopleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPeopleResponse>(
          ListPeopleResponse.$_createMessage);
  static ListPeopleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PersonSummary> get people => $_getList(0);
}

class LabelPersonRequest extends $pb.GeneratedMessage {
  factory LabelPersonRequest({
    $core.String? personId,
    $core.String? name,
  }) {
    final result = LabelPersonRequest._();
    if (personId != null) result.personId = personId;
    if (name != null) result.name = name;
    return result;
  }

  LabelPersonRequest._();

  factory LabelPersonRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LabelPersonRequest()..mergeFromBuffer(data, registry);
  factory LabelPersonRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LabelPersonRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LabelPersonRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: LabelPersonRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'personId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LabelPersonRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LabelPersonRequest copyWith(void Function(LabelPersonRequest) updates) =>
      super.copyWith((message) => updates(message as LabelPersonRequest))
          as LabelPersonRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LabelPersonRequest() / LabelPersonRequest.new instead')
  static LabelPersonRequest create() => LabelPersonRequest._();
  static $pb.GeneratedMessage $_createMessage() => LabelPersonRequest._();
  @$core.override
  LabelPersonRequest createEmptyInstance() => LabelPersonRequest._();
  @$core.pragma('dart2js:noInline')
  static LabelPersonRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LabelPersonRequest>(
          LabelPersonRequest.$_createMessage);
  static LabelPersonRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get personId => $_getSZ(0);
  @$pb.TagNumber(1)
  set personId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPersonId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPersonId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);
}

class LabelPersonResponse extends $pb.GeneratedMessage {
  factory LabelPersonResponse({
    PersonSummary? person,
  }) {
    final result = LabelPersonResponse._();
    if (person != null) result.person = person;
    return result;
  }

  LabelPersonResponse._();

  factory LabelPersonResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LabelPersonResponse()..mergeFromBuffer(data, registry);
  factory LabelPersonResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LabelPersonResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LabelPersonResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: LabelPersonResponse.$_createMessage)
    ..aOM<PersonSummary>(1, _omitFieldNames ? '' : 'person',
        subBuilder: PersonSummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LabelPersonResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LabelPersonResponse copyWith(void Function(LabelPersonResponse) updates) =>
      super.copyWith((message) => updates(message as LabelPersonResponse))
          as LabelPersonResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use LabelPersonResponse() / LabelPersonResponse.new instead')
  static LabelPersonResponse create() => LabelPersonResponse._();
  static $pb.GeneratedMessage $_createMessage() => LabelPersonResponse._();
  @$core.override
  LabelPersonResponse createEmptyInstance() => LabelPersonResponse._();
  @$core.pragma('dart2js:noInline')
  static LabelPersonResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LabelPersonResponse>(
          LabelPersonResponse.$_createMessage);
  static LabelPersonResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PersonSummary get person => $_getN(0);
  @$pb.TagNumber(1)
  set person(PersonSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPerson() => $_has(0);
  @$pb.TagNumber(1)
  void clearPerson() => $_clearField(1);
  @$pb.TagNumber(1)
  PersonSummary ensurePerson() => $_ensure(0);
}

class SetPersonCoverRequest extends $pb.GeneratedMessage {
  factory SetPersonCoverRequest({
    $core.String? personId,
    $core.String? photoId,
  }) {
    final result = SetPersonCoverRequest._();
    if (personId != null) result.personId = personId;
    if (photoId != null) result.photoId = photoId;
    return result;
  }

  SetPersonCoverRequest._();

  factory SetPersonCoverRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetPersonCoverRequest()..mergeFromBuffer(data, registry);
  factory SetPersonCoverRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetPersonCoverRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetPersonCoverRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: SetPersonCoverRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'personId')
    ..aOS(2, _omitFieldNames ? '' : 'photoId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetPersonCoverRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetPersonCoverRequest copyWith(
          void Function(SetPersonCoverRequest) updates) =>
      super.copyWith((message) => updates(message as SetPersonCoverRequest))
          as SetPersonCoverRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetPersonCoverRequest() / SetPersonCoverRequest.new instead')
  static SetPersonCoverRequest create() => SetPersonCoverRequest._();
  static $pb.GeneratedMessage $_createMessage() => SetPersonCoverRequest._();
  @$core.override
  SetPersonCoverRequest createEmptyInstance() => SetPersonCoverRequest._();
  @$core.pragma('dart2js:noInline')
  static SetPersonCoverRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetPersonCoverRequest>(
          SetPersonCoverRequest.$_createMessage);
  static SetPersonCoverRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get personId => $_getSZ(0);
  @$pb.TagNumber(1)
  set personId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPersonId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPersonId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get photoId => $_getSZ(1);
  @$pb.TagNumber(2)
  set photoId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPhotoId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhotoId() => $_clearField(2);
}

class SetPersonCoverResponse extends $pb.GeneratedMessage {
  factory SetPersonCoverResponse({
    PersonSummary? person,
  }) {
    final result = SetPersonCoverResponse._();
    if (person != null) result.person = person;
    return result;
  }

  SetPersonCoverResponse._();

  factory SetPersonCoverResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetPersonCoverResponse()..mergeFromBuffer(data, registry);
  factory SetPersonCoverResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetPersonCoverResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetPersonCoverResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: SetPersonCoverResponse.$_createMessage)
    ..aOM<PersonSummary>(1, _omitFieldNames ? '' : 'person',
        subBuilder: PersonSummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetPersonCoverResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetPersonCoverResponse copyWith(
          void Function(SetPersonCoverResponse) updates) =>
      super.copyWith((message) => updates(message as SetPersonCoverResponse))
          as SetPersonCoverResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetPersonCoverResponse() / SetPersonCoverResponse.new instead')
  static SetPersonCoverResponse create() => SetPersonCoverResponse._();
  static $pb.GeneratedMessage $_createMessage() => SetPersonCoverResponse._();
  @$core.override
  SetPersonCoverResponse createEmptyInstance() => SetPersonCoverResponse._();
  @$core.pragma('dart2js:noInline')
  static SetPersonCoverResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetPersonCoverResponse>(
          SetPersonCoverResponse.$_createMessage);
  static SetPersonCoverResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PersonSummary get person => $_getN(0);
  @$pb.TagNumber(1)
  set person(PersonSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPerson() => $_has(0);
  @$pb.TagNumber(1)
  void clearPerson() => $_clearField(1);
  @$pb.TagNumber(1)
  PersonSummary ensurePerson() => $_ensure(0);
}

class SetAlbumCoverRequest extends $pb.GeneratedMessage {
  factory SetAlbumCoverRequest({
    $core.String? albumId,
    $core.String? photoId,
  }) {
    final result = SetAlbumCoverRequest._();
    if (albumId != null) result.albumId = albumId;
    if (photoId != null) result.photoId = photoId;
    return result;
  }

  SetAlbumCoverRequest._();

  factory SetAlbumCoverRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetAlbumCoverRequest()..mergeFromBuffer(data, registry);
  factory SetAlbumCoverRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetAlbumCoverRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetAlbumCoverRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: SetAlbumCoverRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'albumId')
    ..aOS(2, _omitFieldNames ? '' : 'photoId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAlbumCoverRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAlbumCoverRequest copyWith(void Function(SetAlbumCoverRequest) updates) =>
      super.copyWith((message) => updates(message as SetAlbumCoverRequest))
          as SetAlbumCoverRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetAlbumCoverRequest() / SetAlbumCoverRequest.new instead')
  static SetAlbumCoverRequest create() => SetAlbumCoverRequest._();
  static $pb.GeneratedMessage $_createMessage() => SetAlbumCoverRequest._();
  @$core.override
  SetAlbumCoverRequest createEmptyInstance() => SetAlbumCoverRequest._();
  @$core.pragma('dart2js:noInline')
  static SetAlbumCoverRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetAlbumCoverRequest>(
          SetAlbumCoverRequest.$_createMessage);
  static SetAlbumCoverRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get albumId => $_getSZ(0);
  @$pb.TagNumber(1)
  set albumId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAlbumId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlbumId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get photoId => $_getSZ(1);
  @$pb.TagNumber(2)
  set photoId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPhotoId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhotoId() => $_clearField(2);
}

class SetAlbumCoverResponse extends $pb.GeneratedMessage {
  factory SetAlbumCoverResponse({
    AlbumSummary? album,
  }) {
    final result = SetAlbumCoverResponse._();
    if (album != null) result.album = album;
    return result;
  }

  SetAlbumCoverResponse._();

  factory SetAlbumCoverResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetAlbumCoverResponse()..mergeFromBuffer(data, registry);
  factory SetAlbumCoverResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetAlbumCoverResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetAlbumCoverResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: SetAlbumCoverResponse.$_createMessage)
    ..aOM<AlbumSummary>(1, _omitFieldNames ? '' : 'album',
        subBuilder: AlbumSummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAlbumCoverResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAlbumCoverResponse copyWith(
          void Function(SetAlbumCoverResponse) updates) =>
      super.copyWith((message) => updates(message as SetAlbumCoverResponse))
          as SetAlbumCoverResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetAlbumCoverResponse() / SetAlbumCoverResponse.new instead')
  static SetAlbumCoverResponse create() => SetAlbumCoverResponse._();
  static $pb.GeneratedMessage $_createMessage() => SetAlbumCoverResponse._();
  @$core.override
  SetAlbumCoverResponse createEmptyInstance() => SetAlbumCoverResponse._();
  @$core.pragma('dart2js:noInline')
  static SetAlbumCoverResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetAlbumCoverResponse>(
          SetAlbumCoverResponse.$_createMessage);
  static SetAlbumCoverResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AlbumSummary get album => $_getN(0);
  @$pb.TagNumber(1)
  set album(AlbumSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAlbum() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlbum() => $_clearField(1);
  @$pb.TagNumber(1)
  AlbumSummary ensureAlbum() => $_ensure(0);
}

class AlbumSummary extends $pb.GeneratedMessage {
  factory AlbumSummary({
    $core.String? id,
    $core.String? name,
    $core.int? photoCount,
    $core.String? coverPhotoId,
    $core.bool? encrypted,
    $core.bool? hasVideoCover,
  }) {
    final result = AlbumSummary._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (photoCount != null) result.photoCount = photoCount;
    if (coverPhotoId != null) result.coverPhotoId = coverPhotoId;
    if (encrypted != null) result.encrypted = encrypted;
    if (hasVideoCover != null) result.hasVideoCover = hasVideoCover;
    return result;
  }

  AlbumSummary._();

  factory AlbumSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AlbumSummary()..mergeFromBuffer(data, registry);
  factory AlbumSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AlbumSummary()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AlbumSummary',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: AlbumSummary.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aI(3, _omitFieldNames ? '' : 'photoCount')
    ..aOS(4, _omitFieldNames ? '' : 'coverPhotoId')
    ..aOB(5, _omitFieldNames ? '' : 'encrypted')
    ..aOB(6, _omitFieldNames ? '' : 'hasVideoCover')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AlbumSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AlbumSummary copyWith(void Function(AlbumSummary) updates) =>
      super.copyWith((message) => updates(message as AlbumSummary))
          as AlbumSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AlbumSummary() / AlbumSummary.new instead')
  static AlbumSummary create() => AlbumSummary._();
  static $pb.GeneratedMessage $_createMessage() => AlbumSummary._();
  @$core.override
  AlbumSummary createEmptyInstance() => AlbumSummary._();
  @$core.pragma('dart2js:noInline')
  static AlbumSummary getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AlbumSummary>(
          AlbumSummary.$_createMessage);
  static AlbumSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get photoCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set photoCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPhotoCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearPhotoCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get coverPhotoId => $_getSZ(3);
  @$pb.TagNumber(4)
  set coverPhotoId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCoverPhotoId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoverPhotoId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get encrypted => $_getBF(4);
  @$pb.TagNumber(5)
  set encrypted($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEncrypted() => $_has(4);
  @$pb.TagNumber(5)
  void clearEncrypted() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get hasVideoCover => $_getBF(5);
  @$pb.TagNumber(6)
  set hasVideoCover($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHasVideoCover() => $_has(5);
  @$pb.TagNumber(6)
  void clearHasVideoCover() => $_clearField(6);
}

class PlaceSummary extends $pb.GeneratedMessage {
  factory PlaceSummary({
    $core.String? id,
    $core.String? name,
    $core.int? photoCount,
    $core.double? latitude,
    $core.double? longitude,
    $core.String? coverPhotoId,
  }) {
    final result = PlaceSummary._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (photoCount != null) result.photoCount = photoCount;
    if (latitude != null) result.latitude = latitude;
    if (longitude != null) result.longitude = longitude;
    if (coverPhotoId != null) result.coverPhotoId = coverPhotoId;
    return result;
  }

  PlaceSummary._();

  factory PlaceSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlaceSummary()..mergeFromBuffer(data, registry);
  factory PlaceSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlaceSummary()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaceSummary',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: PlaceSummary.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aI(3, _omitFieldNames ? '' : 'photoCount')
    ..aD(4, _omitFieldNames ? '' : 'latitude')
    ..aD(5, _omitFieldNames ? '' : 'longitude')
    ..aOS(6, _omitFieldNames ? '' : 'coverPhotoId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceSummary copyWith(void Function(PlaceSummary) updates) =>
      super.copyWith((message) => updates(message as PlaceSummary))
          as PlaceSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PlaceSummary() / PlaceSummary.new instead')
  static PlaceSummary create() => PlaceSummary._();
  static $pb.GeneratedMessage $_createMessage() => PlaceSummary._();
  @$core.override
  PlaceSummary createEmptyInstance() => PlaceSummary._();
  @$core.pragma('dart2js:noInline')
  static PlaceSummary getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlaceSummary>(
          PlaceSummary.$_createMessage);
  static PlaceSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get photoCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set photoCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPhotoCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearPhotoCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get latitude => $_getN(3);
  @$pb.TagNumber(4)
  set latitude($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLatitude() => $_has(3);
  @$pb.TagNumber(4)
  void clearLatitude() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get longitude => $_getN(4);
  @$pb.TagNumber(5)
  set longitude($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLongitude() => $_has(4);
  @$pb.TagNumber(5)
  void clearLongitude() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get coverPhotoId => $_getSZ(5);
  @$pb.TagNumber(6)
  set coverPhotoId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCoverPhotoId() => $_has(5);
  @$pb.TagNumber(6)
  void clearCoverPhotoId() => $_clearField(6);
}

class GetPersonDetailsRequest extends $pb.GeneratedMessage {
  factory GetPersonDetailsRequest({
    $core.String? personId,
  }) {
    final result = GetPersonDetailsRequest._();
    if (personId != null) result.personId = personId;
    return result;
  }

  GetPersonDetailsRequest._();

  factory GetPersonDetailsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPersonDetailsRequest()..mergeFromBuffer(data, registry);
  factory GetPersonDetailsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPersonDetailsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPersonDetailsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: GetPersonDetailsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'personId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPersonDetailsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPersonDetailsRequest copyWith(
          void Function(GetPersonDetailsRequest) updates) =>
      super.copyWith((message) => updates(message as GetPersonDetailsRequest))
          as GetPersonDetailsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPersonDetailsRequest() / GetPersonDetailsRequest.new instead')
  static GetPersonDetailsRequest create() => GetPersonDetailsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetPersonDetailsRequest._();
  @$core.override
  GetPersonDetailsRequest createEmptyInstance() => GetPersonDetailsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPersonDetailsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPersonDetailsRequest>(
          GetPersonDetailsRequest.$_createMessage);
  static GetPersonDetailsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get personId => $_getSZ(0);
  @$pb.TagNumber(1)
  set personId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPersonId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPersonId() => $_clearField(1);
}

class GetPersonDetailsResponse extends $pb.GeneratedMessage {
  factory GetPersonDetailsResponse({
    PersonSummary? person,
    $core.Iterable<AlbumSummary>? albums,
    $core.Iterable<PlaceSummary>? places,
    $core.Iterable<PhotoSummary>? photos,
  }) {
    final result = GetPersonDetailsResponse._();
    if (person != null) result.person = person;
    if (albums != null) result.albums.addAll(albums);
    if (places != null) result.places.addAll(places);
    if (photos != null) result.photos.addAll(photos);
    return result;
  }

  GetPersonDetailsResponse._();

  factory GetPersonDetailsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPersonDetailsResponse()..mergeFromBuffer(data, registry);
  factory GetPersonDetailsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPersonDetailsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPersonDetailsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: GetPersonDetailsResponse.$_createMessage)
    ..aOM<PersonSummary>(1, _omitFieldNames ? '' : 'person',
        subBuilder: PersonSummary.$_createMessage)
    ..pPM<AlbumSummary>(2, _omitFieldNames ? '' : 'albums',
        subBuilder: AlbumSummary.$_createMessage)
    ..pPM<PlaceSummary>(3, _omitFieldNames ? '' : 'places',
        subBuilder: PlaceSummary.$_createMessage)
    ..pPM<PhotoSummary>(4, _omitFieldNames ? '' : 'photos',
        subBuilder: PhotoSummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPersonDetailsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPersonDetailsResponse copyWith(
          void Function(GetPersonDetailsResponse) updates) =>
      super.copyWith((message) => updates(message as GetPersonDetailsResponse))
          as GetPersonDetailsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPersonDetailsResponse() / GetPersonDetailsResponse.new instead')
  static GetPersonDetailsResponse create() => GetPersonDetailsResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetPersonDetailsResponse._();
  @$core.override
  GetPersonDetailsResponse createEmptyInstance() =>
      GetPersonDetailsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetPersonDetailsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPersonDetailsResponse>(
          GetPersonDetailsResponse.$_createMessage);
  static GetPersonDetailsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PersonSummary get person => $_getN(0);
  @$pb.TagNumber(1)
  set person(PersonSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPerson() => $_has(0);
  @$pb.TagNumber(1)
  void clearPerson() => $_clearField(1);
  @$pb.TagNumber(1)
  PersonSummary ensurePerson() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<AlbumSummary> get albums => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<PlaceSummary> get places => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<PhotoSummary> get photos => $_getList(3);
}

class ListAlbumsRequest extends $pb.GeneratedMessage {
  factory ListAlbumsRequest() => ListAlbumsRequest._();

  ListAlbumsRequest._();

  factory ListAlbumsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAlbumsRequest()..mergeFromBuffer(data, registry);
  factory ListAlbumsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAlbumsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAlbumsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: ListAlbumsRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAlbumsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAlbumsRequest copyWith(void Function(ListAlbumsRequest) updates) =>
      super.copyWith((message) => updates(message as ListAlbumsRequest))
          as ListAlbumsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListAlbumsRequest() / ListAlbumsRequest.new instead')
  static ListAlbumsRequest create() => ListAlbumsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListAlbumsRequest._();
  @$core.override
  ListAlbumsRequest createEmptyInstance() => ListAlbumsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListAlbumsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListAlbumsRequest>(
          ListAlbumsRequest.$_createMessage);
  static ListAlbumsRequest? _defaultInstance;
}

class ListAlbumsResponse extends $pb.GeneratedMessage {
  factory ListAlbumsResponse({
    $core.Iterable<AlbumSummary>? albums,
  }) {
    final result = ListAlbumsResponse._();
    if (albums != null) result.albums.addAll(albums);
    return result;
  }

  ListAlbumsResponse._();

  factory ListAlbumsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAlbumsResponse()..mergeFromBuffer(data, registry);
  factory ListAlbumsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAlbumsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAlbumsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: ListAlbumsResponse.$_createMessage)
    ..pPM<AlbumSummary>(1, _omitFieldNames ? '' : 'albums',
        subBuilder: AlbumSummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAlbumsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAlbumsResponse copyWith(void Function(ListAlbumsResponse) updates) =>
      super.copyWith((message) => updates(message as ListAlbumsResponse))
          as ListAlbumsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListAlbumsResponse() / ListAlbumsResponse.new instead')
  static ListAlbumsResponse create() => ListAlbumsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListAlbumsResponse._();
  @$core.override
  ListAlbumsResponse createEmptyInstance() => ListAlbumsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListAlbumsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAlbumsResponse>(
          ListAlbumsResponse.$_createMessage);
  static ListAlbumsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AlbumSummary> get albums => $_getList(0);
}

class CreateAlbumRequest extends $pb.GeneratedMessage {
  factory CreateAlbumRequest({
    $core.String? name,
  }) {
    final result = CreateAlbumRequest._();
    if (name != null) result.name = name;
    return result;
  }

  CreateAlbumRequest._();

  factory CreateAlbumRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateAlbumRequest()..mergeFromBuffer(data, registry);
  factory CreateAlbumRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateAlbumRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateAlbumRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: CreateAlbumRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAlbumRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAlbumRequest copyWith(void Function(CreateAlbumRequest) updates) =>
      super.copyWith((message) => updates(message as CreateAlbumRequest))
          as CreateAlbumRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CreateAlbumRequest() / CreateAlbumRequest.new instead')
  static CreateAlbumRequest create() => CreateAlbumRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateAlbumRequest._();
  @$core.override
  CreateAlbumRequest createEmptyInstance() => CreateAlbumRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateAlbumRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateAlbumRequest>(
          CreateAlbumRequest.$_createMessage);
  static CreateAlbumRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);
}

class CreateAlbumResponse extends $pb.GeneratedMessage {
  factory CreateAlbumResponse({
    AlbumSummary? album,
  }) {
    final result = CreateAlbumResponse._();
    if (album != null) result.album = album;
    return result;
  }

  CreateAlbumResponse._();

  factory CreateAlbumResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateAlbumResponse()..mergeFromBuffer(data, registry);
  factory CreateAlbumResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateAlbumResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateAlbumResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: CreateAlbumResponse.$_createMessage)
    ..aOM<AlbumSummary>(1, _omitFieldNames ? '' : 'album',
        subBuilder: AlbumSummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAlbumResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAlbumResponse copyWith(void Function(CreateAlbumResponse) updates) =>
      super.copyWith((message) => updates(message as CreateAlbumResponse))
          as CreateAlbumResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use CreateAlbumResponse() / CreateAlbumResponse.new instead')
  static CreateAlbumResponse create() => CreateAlbumResponse._();
  static $pb.GeneratedMessage $_createMessage() => CreateAlbumResponse._();
  @$core.override
  CreateAlbumResponse createEmptyInstance() => CreateAlbumResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateAlbumResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateAlbumResponse>(
          CreateAlbumResponse.$_createMessage);
  static CreateAlbumResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AlbumSummary get album => $_getN(0);
  @$pb.TagNumber(1)
  set album(AlbumSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAlbum() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlbum() => $_clearField(1);
  @$pb.TagNumber(1)
  AlbumSummary ensureAlbum() => $_ensure(0);
}

class ListPlacesRequest extends $pb.GeneratedMessage {
  factory ListPlacesRequest() => ListPlacesRequest._();

  ListPlacesRequest._();

  factory ListPlacesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPlacesRequest()..mergeFromBuffer(data, registry);
  factory ListPlacesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPlacesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPlacesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: ListPlacesRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPlacesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPlacesRequest copyWith(void Function(ListPlacesRequest) updates) =>
      super.copyWith((message) => updates(message as ListPlacesRequest))
          as ListPlacesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListPlacesRequest() / ListPlacesRequest.new instead')
  static ListPlacesRequest create() => ListPlacesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListPlacesRequest._();
  @$core.override
  ListPlacesRequest createEmptyInstance() => ListPlacesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListPlacesRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListPlacesRequest>(
          ListPlacesRequest.$_createMessage);
  static ListPlacesRequest? _defaultInstance;
}

class ListPlacesResponse extends $pb.GeneratedMessage {
  factory ListPlacesResponse({
    $core.Iterable<PlaceSummary>? places,
  }) {
    final result = ListPlacesResponse._();
    if (places != null) result.places.addAll(places);
    return result;
  }

  ListPlacesResponse._();

  factory ListPlacesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPlacesResponse()..mergeFromBuffer(data, registry);
  factory ListPlacesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPlacesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPlacesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: ListPlacesResponse.$_createMessage)
    ..pPM<PlaceSummary>(1, _omitFieldNames ? '' : 'places',
        subBuilder: PlaceSummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPlacesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPlacesResponse copyWith(void Function(ListPlacesResponse) updates) =>
      super.copyWith((message) => updates(message as ListPlacesResponse))
          as ListPlacesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListPlacesResponse() / ListPlacesResponse.new instead')
  static ListPlacesResponse create() => ListPlacesResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListPlacesResponse._();
  @$core.override
  ListPlacesResponse createEmptyInstance() => ListPlacesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListPlacesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPlacesResponse>(
          ListPlacesResponse.$_createMessage);
  static ListPlacesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PlaceSummary> get places => $_getList(0);
}

class PhotoServiceApi {
  final $pb.RpcClient _client;

  PhotoServiceApi(this._client);

  $async.Future<GetTimelineResponse> getTimeline(
          $pb.ClientContext? ctx, GetTimelineRequest request) =>
      _client.invoke<GetTimelineResponse>(
          ctx, 'PhotoService', 'GetTimeline', request, GetTimelineResponse());

  /// Photo count per month, newest first. Tiny; lets the client lay out the
  /// whole timeline and jump anywhere before loading a single photo.
  $async.Future<GetTimelineBucketsResponse> getTimelineBuckets(
          $pb.ClientContext? ctx, GetTimelineBucketsRequest request) =>
      _client.invoke<GetTimelineBucketsResponse>(ctx, 'PhotoService',
          'GetTimelineBuckets', request, GetTimelineBucketsResponse());
  $async.Future<Chunk> streamThumbnail(
          $pb.ClientContext? ctx, GetThumbnailRequest request) =>
      _client.invoke<Chunk>(
          ctx, 'PhotoService', 'StreamThumbnail', request, Chunk());
  $async.Future<Chunk> streamFullImage(
          $pb.ClientContext? ctx, GetFullImageRequest request) =>
      _client.invoke<Chunk>(
          ctx, 'PhotoService', 'StreamFullImage', request, Chunk());
  $async.Future<GetPhotoDetailsResponse> getPhotoDetails(
          $pb.ClientContext? ctx, GetPhotoDetailsRequest request) =>
      _client.invoke<GetPhotoDetailsResponse>(ctx, 'PhotoService',
          'GetPhotoDetails', request, GetPhotoDetailsResponse());

  /// Acciones sobre fotos (Pantalla 7 - Visor)
  $async.Future<ToggleFavoriteResponse> toggleFavorite(
          $pb.ClientContext? ctx, ToggleFavoriteRequest request) =>
      _client.invoke<ToggleFavoriteResponse>(ctx, 'PhotoService',
          'ToggleFavorite', request, ToggleFavoriteResponse());
  $async.Future<DeletePhotoResponse> deletePhoto(
          $pb.ClientContext? ctx, DeletePhotoRequest request) =>
      _client.invoke<DeletePhotoResponse>(
          ctx, 'PhotoService', 'DeletePhoto', request, DeletePhotoResponse());
  $async.Future<AddPhotoToAlbumResponse> addPhotoToAlbum(
          $pb.ClientContext? ctx, AddPhotoToAlbumRequest request) =>
      _client.invoke<AddPhotoToAlbumResponse>(ctx, 'PhotoService',
          'AddPhotoToAlbum', request, AddPhotoToAlbumResponse());
  $async.Future<ListPeopleResponse> listPeople(
          $pb.ClientContext? ctx, ListPeopleRequest request) =>
      _client.invoke<ListPeopleResponse>(
          ctx, 'PhotoService', 'ListPeople', request, ListPeopleResponse());
  $async.Future<LabelPersonResponse> labelPerson(
          $pb.ClientContext? ctx, LabelPersonRequest request) =>
      _client.invoke<LabelPersonResponse>(
          ctx, 'PhotoService', 'LabelPerson', request, LabelPersonResponse());
  $async.Future<GetPersonDetailsResponse> getPersonDetails(
          $pb.ClientContext? ctx, GetPersonDetailsRequest request) =>
      _client.invoke<GetPersonDetailsResponse>(ctx, 'PhotoService',
          'GetPersonDetails', request, GetPersonDetailsResponse());
  $async.Future<SetPersonCoverResponse> setPersonCover(
          $pb.ClientContext? ctx, SetPersonCoverRequest request) =>
      _client.invoke<SetPersonCoverResponse>(ctx, 'PhotoService',
          'SetPersonCover', request, SetPersonCoverResponse());
  $async.Future<ListAlbumsResponse> listAlbums(
          $pb.ClientContext? ctx, ListAlbumsRequest request) =>
      _client.invoke<ListAlbumsResponse>(
          ctx, 'PhotoService', 'ListAlbums', request, ListAlbumsResponse());
  $async.Future<CreateAlbumResponse> createAlbum(
          $pb.ClientContext? ctx, CreateAlbumRequest request) =>
      _client.invoke<CreateAlbumResponse>(
          ctx, 'PhotoService', 'CreateAlbum', request, CreateAlbumResponse());
  $async.Future<SetAlbumCoverResponse> setAlbumCover(
          $pb.ClientContext? ctx, SetAlbumCoverRequest request) =>
      _client.invoke<SetAlbumCoverResponse>(ctx, 'PhotoService',
          'SetAlbumCover', request, SetAlbumCoverResponse());
  $async.Future<ListPlacesResponse> listPlaces(
          $pb.ClientContext? ctx, ListPlacesRequest request) =>
      _client.invoke<ListPlacesResponse>(
          ctx, 'PhotoService', 'ListPlaces', request, ListPlacesResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
