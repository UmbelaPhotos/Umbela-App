// This is a generated file - do not edit.
//
// Generated from v1/photo.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use chunkDescriptor instead')
const Chunk$json = {
  '1': 'Chunk',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `Chunk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chunkDescriptor =
    $convert.base64Decode('CgVDaHVuaxISCgRkYXRhGAEgASgMUgRkYXRh');

@$core.Deprecated('Use photoSummaryDescriptor instead')
const PhotoSummary$json = {
  '1': 'PhotoSummary',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'taken_at_unix', '3': 2, '4': 1, '5': 3, '10': 'takenAtUnix'},
    {'1': 'is_video', '3': 3, '4': 1, '5': 8, '10': 'isVideo'},
    {'1': 'blurhash', '3': 4, '4': 1, '5': 9, '10': 'blurhash'},
    {'1': 'width', '3': 5, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 6, '4': 1, '5': 5, '10': 'height'},
    {'1': 'favorite', '3': 7, '4': 1, '5': 8, '10': 'favorite'},
  ],
};

/// Descriptor for `PhotoSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List photoSummaryDescriptor = $convert.base64Decode(
    'CgxQaG90b1N1bW1hcnkSDgoCaWQYASABKAlSAmlkEiIKDXRha2VuX2F0X3VuaXgYAiABKANSC3'
    'Rha2VuQXRVbml4EhkKCGlzX3ZpZGVvGAMgASgIUgdpc1ZpZGVvEhoKCGJsdXJoYXNoGAQgASgJ'
    'UghibHVyaGFzaBIUCgV3aWR0aBgFIAEoBVIFd2lkdGgSFgoGaGVpZ2h0GAYgASgFUgZoZWlnaH'
    'QSGgoIZmF2b3JpdGUYByABKAhSCGZhdm9yaXRl');

@$core.Deprecated('Use getTimelineRequestDescriptor instead')
const GetTimelineRequest$json = {
  '1': 'GetTimelineRequest',
  '2': [
    {'1': 'from_unix', '3': 1, '4': 1, '5': 3, '10': 'fromUnix'},
    {'1': 'to_unix', '3': 2, '4': 1, '5': 3, '10': 'toUnix'},
    {'1': 'person_id', '3': 3, '4': 1, '5': 9, '10': 'personId'},
    {'1': 'album_id', '3': 4, '4': 1, '5': 9, '10': 'albumId'},
    {'1': 'place_id', '3': 5, '4': 1, '5': 9, '10': 'placeId'},
    {'1': 'page_size', '3': 6, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'cursor', '3': 7, '4': 1, '5': 9, '10': 'cursor'},
  ],
};

/// Descriptor for `GetTimelineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTimelineRequestDescriptor = $convert.base64Decode(
    'ChJHZXRUaW1lbGluZVJlcXVlc3QSGwoJZnJvbV91bml4GAEgASgDUghmcm9tVW5peBIXCgd0b1'
    '91bml4GAIgASgDUgZ0b1VuaXgSGwoJcGVyc29uX2lkGAMgASgJUghwZXJzb25JZBIZCghhbGJ1'
    'bV9pZBgEIAEoCVIHYWxidW1JZBIZCghwbGFjZV9pZBgFIAEoCVIHcGxhY2VJZBIbCglwYWdlX3'
    'NpemUYBiABKAVSCHBhZ2VTaXplEhYKBmN1cnNvchgHIAEoCVIGY3Vyc29y');

@$core.Deprecated('Use getTimelineResponseDescriptor instead')
const GetTimelineResponse$json = {
  '1': 'GetTimelineResponse',
  '2': [
    {
      '1': 'photos',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.umbela.v1.PhotoSummary',
      '10': 'photos'
    },
    {'1': 'next_cursor', '3': 2, '4': 1, '5': 9, '10': 'nextCursor'},
  ],
};

/// Descriptor for `GetTimelineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTimelineResponseDescriptor = $convert.base64Decode(
    'ChNHZXRUaW1lbGluZVJlc3BvbnNlEi8KBnBob3RvcxgBIAMoCzIXLnVtYmVsYS52MS5QaG90b1'
    'N1bW1hcnlSBnBob3RvcxIfCgtuZXh0X2N1cnNvchgCIAEoCVIKbmV4dEN1cnNvcg==');

@$core.Deprecated('Use getTimelineBucketsRequestDescriptor instead')
const GetTimelineBucketsRequest$json = {
  '1': 'GetTimelineBucketsRequest',
  '2': [
    {'1': 'tz_offset_seconds', '3': 1, '4': 1, '5': 5, '10': 'tzOffsetSeconds'},
  ],
};

/// Descriptor for `GetTimelineBucketsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTimelineBucketsRequestDescriptor =
    $convert.base64Decode(
        'ChlHZXRUaW1lbGluZUJ1Y2tldHNSZXF1ZXN0EioKEXR6X29mZnNldF9zZWNvbmRzGAEgASgFUg'
        '90ek9mZnNldFNlY29uZHM=');

@$core.Deprecated('Use timelineBucketDescriptor instead')
const TimelineBucket$json = {
  '1': 'TimelineBucket',
  '2': [
    {'1': 'year', '3': 1, '4': 1, '5': 5, '10': 'year'},
    {'1': 'month', '3': 2, '4': 1, '5': 5, '10': 'month'},
    {'1': 'count', '3': 3, '4': 1, '5': 5, '10': 'count'},
    {'1': 'from_unix', '3': 4, '4': 1, '5': 3, '10': 'fromUnix'},
    {'1': 'to_unix', '3': 5, '4': 1, '5': 3, '10': 'toUnix'},
  ],
};

/// Descriptor for `TimelineBucket`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timelineBucketDescriptor = $convert.base64Decode(
    'Cg5UaW1lbGluZUJ1Y2tldBISCgR5ZWFyGAEgASgFUgR5ZWFyEhQKBW1vbnRoGAIgASgFUgVtb2'
    '50aBIUCgVjb3VudBgDIAEoBVIFY291bnQSGwoJZnJvbV91bml4GAQgASgDUghmcm9tVW5peBIX'
    'Cgd0b191bml4GAUgASgDUgZ0b1VuaXg=');

@$core.Deprecated('Use getTimelineBucketsResponseDescriptor instead')
const GetTimelineBucketsResponse$json = {
  '1': 'GetTimelineBucketsResponse',
  '2': [
    {
      '1': 'buckets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.umbela.v1.TimelineBucket',
      '10': 'buckets'
    },
  ],
};

/// Descriptor for `GetTimelineBucketsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTimelineBucketsResponseDescriptor =
    $convert.base64Decode(
        'ChpHZXRUaW1lbGluZUJ1Y2tldHNSZXNwb25zZRIzCgdidWNrZXRzGAEgAygLMhkudW1iZWxhLn'
        'YxLlRpbWVsaW5lQnVja2V0UgdidWNrZXRz');

@$core.Deprecated('Use getThumbnailRequestDescriptor instead')
const GetThumbnailRequest$json = {
  '1': 'GetThumbnailRequest',
  '2': [
    {'1': 'photo_id', '3': 1, '4': 1, '5': 9, '10': 'photoId'},
    {'1': 'max_size', '3': 2, '4': 1, '5': 5, '10': 'maxSize'},
  ],
};

/// Descriptor for `GetThumbnailRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getThumbnailRequestDescriptor = $convert.base64Decode(
    'ChNHZXRUaHVtYm5haWxSZXF1ZXN0EhkKCHBob3RvX2lkGAEgASgJUgdwaG90b0lkEhkKCG1heF'
    '9zaXplGAIgASgFUgdtYXhTaXpl');

@$core.Deprecated('Use getFullImageRequestDescriptor instead')
const GetFullImageRequest$json = {
  '1': 'GetFullImageRequest',
  '2': [
    {'1': 'photo_id', '3': 1, '4': 1, '5': 9, '10': 'photoId'},
  ],
};

/// Descriptor for `GetFullImageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFullImageRequestDescriptor =
    $convert.base64Decode(
        'ChNHZXRGdWxsSW1hZ2VSZXF1ZXN0EhkKCHBob3RvX2lkGAEgASgJUgdwaG90b0lk');

@$core.Deprecated('Use faceInPhotoDescriptor instead')
const FaceInPhoto$json = {
  '1': 'FaceInPhoto',
  '2': [
    {'1': 'person_id', '3': 1, '4': 1, '5': 9, '10': 'personId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'confidence', '3': 3, '4': 1, '5': 2, '10': 'confidence'},
  ],
};

/// Descriptor for `FaceInPhoto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List faceInPhotoDescriptor = $convert.base64Decode(
    'CgtGYWNlSW5QaG90bxIbCglwZXJzb25faWQYASABKAlSCHBlcnNvbklkEhIKBG5hbWUYAiABKA'
    'lSBG5hbWUSHgoKY29uZmlkZW5jZRgDIAEoAlIKY29uZmlkZW5jZQ==');

@$core.Deprecated('Use photoDetailsDescriptor instead')
const PhotoDetails$json = {
  '1': 'PhotoDetails',
  '2': [
    {
      '1': 'summary',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.umbela.v1.PhotoSummary',
      '10': 'summary'
    },
    {'1': 'uploader', '3': 2, '4': 1, '5': 9, '10': 'uploader'},
    {'1': 'place_name', '3': 3, '4': 1, '5': 9, '10': 'placeName'},
    {'1': 'latitude', '3': 4, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 5, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'iso', '3': 6, '4': 1, '5': 5, '10': 'iso'},
    {'1': 'aperture', '3': 7, '4': 1, '5': 2, '10': 'aperture'},
    {'1': 'encrypted_at_rest', '3': 8, '4': 1, '5': 8, '10': 'encryptedAtRest'},
    {'1': 'favorite', '3': 9, '4': 1, '5': 8, '10': 'favorite'},
    {
      '1': 'faces',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.umbela.v1.FaceInPhoto',
      '10': 'faces'
    },
  ],
};

/// Descriptor for `PhotoDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List photoDetailsDescriptor = $convert.base64Decode(
    'CgxQaG90b0RldGFpbHMSMQoHc3VtbWFyeRgBIAEoCzIXLnVtYmVsYS52MS5QaG90b1N1bW1hcn'
    'lSB3N1bW1hcnkSGgoIdXBsb2FkZXIYAiABKAlSCHVwbG9hZGVyEh0KCnBsYWNlX25hbWUYAyAB'
    'KAlSCXBsYWNlTmFtZRIaCghsYXRpdHVkZRgEIAEoAVIIbGF0aXR1ZGUSHAoJbG9uZ2l0dWRlGA'
    'UgASgBUglsb25naXR1ZGUSEAoDaXNvGAYgASgFUgNpc28SGgoIYXBlcnR1cmUYByABKAJSCGFw'
    'ZXJ0dXJlEioKEWVuY3J5cHRlZF9hdF9yZXN0GAggASgIUg9lbmNyeXB0ZWRBdFJlc3QSGgoIZm'
    'F2b3JpdGUYCSABKAhSCGZhdm9yaXRlEiwKBWZhY2VzGAogAygLMhYudW1iZWxhLnYxLkZhY2VJ'
    'blBob3RvUgVmYWNlcw==');

@$core.Deprecated('Use getPhotoDetailsRequestDescriptor instead')
const GetPhotoDetailsRequest$json = {
  '1': 'GetPhotoDetailsRequest',
  '2': [
    {'1': 'photo_id', '3': 1, '4': 1, '5': 9, '10': 'photoId'},
  ],
};

/// Descriptor for `GetPhotoDetailsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPhotoDetailsRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRQaG90b0RldGFpbHNSZXF1ZXN0EhkKCHBob3RvX2lkGAEgASgJUgdwaG90b0lk');

@$core.Deprecated('Use getPhotoDetailsResponseDescriptor instead')
const GetPhotoDetailsResponse$json = {
  '1': 'GetPhotoDetailsResponse',
  '2': [
    {
      '1': 'photo',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.umbela.v1.PhotoDetails',
      '10': 'photo'
    },
  ],
};

/// Descriptor for `GetPhotoDetailsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPhotoDetailsResponseDescriptor =
    $convert.base64Decode(
        'ChdHZXRQaG90b0RldGFpbHNSZXNwb25zZRItCgVwaG90bxgBIAEoCzIXLnVtYmVsYS52MS5QaG'
        '90b0RldGFpbHNSBXBob3Rv');

@$core.Deprecated('Use toggleFavoriteRequestDescriptor instead')
const ToggleFavoriteRequest$json = {
  '1': 'ToggleFavoriteRequest',
  '2': [
    {'1': 'photo_id', '3': 1, '4': 1, '5': 9, '10': 'photoId'},
  ],
};

/// Descriptor for `ToggleFavoriteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toggleFavoriteRequestDescriptor =
    $convert.base64Decode(
        'ChVUb2dnbGVGYXZvcml0ZVJlcXVlc3QSGQoIcGhvdG9faWQYASABKAlSB3Bob3RvSWQ=');

@$core.Deprecated('Use toggleFavoriteResponseDescriptor instead')
const ToggleFavoriteResponse$json = {
  '1': 'ToggleFavoriteResponse',
  '2': [
    {'1': 'is_favorite', '3': 1, '4': 1, '5': 8, '10': 'isFavorite'},
  ],
};

/// Descriptor for `ToggleFavoriteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toggleFavoriteResponseDescriptor =
    $convert.base64Decode(
        'ChZUb2dnbGVGYXZvcml0ZVJlc3BvbnNlEh8KC2lzX2Zhdm9yaXRlGAEgASgIUgppc0Zhdm9yaX'
        'Rl');

@$core.Deprecated('Use deletePhotoRequestDescriptor instead')
const DeletePhotoRequest$json = {
  '1': 'DeletePhotoRequest',
  '2': [
    {'1': 'photo_id', '3': 1, '4': 1, '5': 9, '10': 'photoId'},
  ],
};

/// Descriptor for `DeletePhotoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deletePhotoRequestDescriptor =
    $convert.base64Decode(
        'ChJEZWxldGVQaG90b1JlcXVlc3QSGQoIcGhvdG9faWQYASABKAlSB3Bob3RvSWQ=');

@$core.Deprecated('Use deletePhotoResponseDescriptor instead')
const DeletePhotoResponse$json = {
  '1': 'DeletePhotoResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `DeletePhotoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deletePhotoResponseDescriptor =
    $convert.base64Decode(
        'ChNEZWxldGVQaG90b1Jlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3M=');

@$core.Deprecated('Use addPhotoToAlbumRequestDescriptor instead')
const AddPhotoToAlbumRequest$json = {
  '1': 'AddPhotoToAlbumRequest',
  '2': [
    {'1': 'photo_id', '3': 1, '4': 1, '5': 9, '10': 'photoId'},
    {'1': 'album_id', '3': 2, '4': 1, '5': 9, '10': 'albumId'},
  ],
};

/// Descriptor for `AddPhotoToAlbumRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addPhotoToAlbumRequestDescriptor =
    $convert.base64Decode(
        'ChZBZGRQaG90b1RvQWxidW1SZXF1ZXN0EhkKCHBob3RvX2lkGAEgASgJUgdwaG90b0lkEhkKCG'
        'FsYnVtX2lkGAIgASgJUgdhbGJ1bUlk');

@$core.Deprecated('Use addPhotoToAlbumResponseDescriptor instead')
const AddPhotoToAlbumResponse$json = {
  '1': 'AddPhotoToAlbumResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `AddPhotoToAlbumResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addPhotoToAlbumResponseDescriptor =
    $convert.base64Decode(
        'ChdBZGRQaG90b1RvQWxidW1SZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');

@$core.Deprecated('Use personSummaryDescriptor instead')
const PersonSummary$json = {
  '1': 'PersonSummary',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'photo_count', '3': 3, '4': 1, '5': 5, '10': 'photoCount'},
    {'1': 'cover_photo_id', '3': 4, '4': 1, '5': 9, '10': 'coverPhotoId'},
  ],
};

/// Descriptor for `PersonSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List personSummaryDescriptor = $convert.base64Decode(
    'Cg1QZXJzb25TdW1tYXJ5Eg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEh8KC3'
    'Bob3RvX2NvdW50GAMgASgFUgpwaG90b0NvdW50EiQKDmNvdmVyX3Bob3RvX2lkGAQgASgJUgxj'
    'b3ZlclBob3RvSWQ=');

@$core.Deprecated('Use listPeopleRequestDescriptor instead')
const ListPeopleRequest$json = {
  '1': 'ListPeopleRequest',
};

/// Descriptor for `ListPeopleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPeopleRequestDescriptor =
    $convert.base64Decode('ChFMaXN0UGVvcGxlUmVxdWVzdA==');

@$core.Deprecated('Use listPeopleResponseDescriptor instead')
const ListPeopleResponse$json = {
  '1': 'ListPeopleResponse',
  '2': [
    {
      '1': 'people',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.umbela.v1.PersonSummary',
      '10': 'people'
    },
  ],
};

/// Descriptor for `ListPeopleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPeopleResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0UGVvcGxlUmVzcG9uc2USMAoGcGVvcGxlGAEgAygLMhgudW1iZWxhLnYxLlBlcnNvbl'
    'N1bW1hcnlSBnBlb3BsZQ==');

@$core.Deprecated('Use labelPersonRequestDescriptor instead')
const LabelPersonRequest$json = {
  '1': 'LabelPersonRequest',
  '2': [
    {'1': 'person_id', '3': 1, '4': 1, '5': 9, '10': 'personId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `LabelPersonRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List labelPersonRequestDescriptor = $convert.base64Decode(
    'ChJMYWJlbFBlcnNvblJlcXVlc3QSGwoJcGVyc29uX2lkGAEgASgJUghwZXJzb25JZBISCgRuYW'
    '1lGAIgASgJUgRuYW1l');

@$core.Deprecated('Use labelPersonResponseDescriptor instead')
const LabelPersonResponse$json = {
  '1': 'LabelPersonResponse',
  '2': [
    {
      '1': 'person',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.umbela.v1.PersonSummary',
      '10': 'person'
    },
  ],
};

/// Descriptor for `LabelPersonResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List labelPersonResponseDescriptor = $convert.base64Decode(
    'ChNMYWJlbFBlcnNvblJlc3BvbnNlEjAKBnBlcnNvbhgBIAEoCzIYLnVtYmVsYS52MS5QZXJzb2'
    '5TdW1tYXJ5UgZwZXJzb24=');

@$core.Deprecated('Use setPersonCoverRequestDescriptor instead')
const SetPersonCoverRequest$json = {
  '1': 'SetPersonCoverRequest',
  '2': [
    {'1': 'person_id', '3': 1, '4': 1, '5': 9, '10': 'personId'},
    {'1': 'photo_id', '3': 2, '4': 1, '5': 9, '10': 'photoId'},
  ],
};

/// Descriptor for `SetPersonCoverRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setPersonCoverRequestDescriptor = $convert.base64Decode(
    'ChVTZXRQZXJzb25Db3ZlclJlcXVlc3QSGwoJcGVyc29uX2lkGAEgASgJUghwZXJzb25JZBIZCg'
    'hwaG90b19pZBgCIAEoCVIHcGhvdG9JZA==');

@$core.Deprecated('Use setPersonCoverResponseDescriptor instead')
const SetPersonCoverResponse$json = {
  '1': 'SetPersonCoverResponse',
  '2': [
    {
      '1': 'person',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.umbela.v1.PersonSummary',
      '10': 'person'
    },
  ],
};

/// Descriptor for `SetPersonCoverResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setPersonCoverResponseDescriptor =
    $convert.base64Decode(
        'ChZTZXRQZXJzb25Db3ZlclJlc3BvbnNlEjAKBnBlcnNvbhgBIAEoCzIYLnVtYmVsYS52MS5QZX'
        'Jzb25TdW1tYXJ5UgZwZXJzb24=');

@$core.Deprecated('Use setAlbumCoverRequestDescriptor instead')
const SetAlbumCoverRequest$json = {
  '1': 'SetAlbumCoverRequest',
  '2': [
    {'1': 'album_id', '3': 1, '4': 1, '5': 9, '10': 'albumId'},
    {'1': 'photo_id', '3': 2, '4': 1, '5': 9, '10': 'photoId'},
  ],
};

/// Descriptor for `SetAlbumCoverRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setAlbumCoverRequestDescriptor = $convert.base64Decode(
    'ChRTZXRBbGJ1bUNvdmVyUmVxdWVzdBIZCghhbGJ1bV9pZBgBIAEoCVIHYWxidW1JZBIZCghwaG'
    '90b19pZBgCIAEoCVIHcGhvdG9JZA==');

@$core.Deprecated('Use setAlbumCoverResponseDescriptor instead')
const SetAlbumCoverResponse$json = {
  '1': 'SetAlbumCoverResponse',
  '2': [
    {
      '1': 'album',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.umbela.v1.AlbumSummary',
      '10': 'album'
    },
  ],
};

/// Descriptor for `SetAlbumCoverResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setAlbumCoverResponseDescriptor = $convert.base64Decode(
    'ChVTZXRBbGJ1bUNvdmVyUmVzcG9uc2USLQoFYWxidW0YASABKAsyFy51bWJlbGEudjEuQWxidW'
    '1TdW1tYXJ5UgVhbGJ1bQ==');

@$core.Deprecated('Use albumSummaryDescriptor instead')
const AlbumSummary$json = {
  '1': 'AlbumSummary',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'photo_count', '3': 3, '4': 1, '5': 5, '10': 'photoCount'},
    {'1': 'cover_photo_id', '3': 4, '4': 1, '5': 9, '10': 'coverPhotoId'},
    {'1': 'encrypted', '3': 5, '4': 1, '5': 8, '10': 'encrypted'},
    {'1': 'has_video_cover', '3': 6, '4': 1, '5': 8, '10': 'hasVideoCover'},
  ],
};

/// Descriptor for `AlbumSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List albumSummaryDescriptor = $convert.base64Decode(
    'CgxBbGJ1bVN1bW1hcnkSDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSHwoLcG'
    'hvdG9fY291bnQYAyABKAVSCnBob3RvQ291bnQSJAoOY292ZXJfcGhvdG9faWQYBCABKAlSDGNv'
    'dmVyUGhvdG9JZBIcCgllbmNyeXB0ZWQYBSABKAhSCWVuY3J5cHRlZBImCg9oYXNfdmlkZW9fY2'
    '92ZXIYBiABKAhSDWhhc1ZpZGVvQ292ZXI=');

@$core.Deprecated('Use placeSummaryDescriptor instead')
const PlaceSummary$json = {
  '1': 'PlaceSummary',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'photo_count', '3': 3, '4': 1, '5': 5, '10': 'photoCount'},
    {'1': 'latitude', '3': 4, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 5, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'cover_photo_id', '3': 6, '4': 1, '5': 9, '10': 'coverPhotoId'},
  ],
};

/// Descriptor for `PlaceSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List placeSummaryDescriptor = $convert.base64Decode(
    'CgxQbGFjZVN1bW1hcnkSDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSHwoLcG'
    'hvdG9fY291bnQYAyABKAVSCnBob3RvQ291bnQSGgoIbGF0aXR1ZGUYBCABKAFSCGxhdGl0dWRl'
    'EhwKCWxvbmdpdHVkZRgFIAEoAVIJbG9uZ2l0dWRlEiQKDmNvdmVyX3Bob3RvX2lkGAYgASgJUg'
    'xjb3ZlclBob3RvSWQ=');

@$core.Deprecated('Use getPersonDetailsRequestDescriptor instead')
const GetPersonDetailsRequest$json = {
  '1': 'GetPersonDetailsRequest',
  '2': [
    {'1': 'person_id', '3': 1, '4': 1, '5': 9, '10': 'personId'},
  ],
};

/// Descriptor for `GetPersonDetailsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPersonDetailsRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRQZXJzb25EZXRhaWxzUmVxdWVzdBIbCglwZXJzb25faWQYASABKAlSCHBlcnNvbklk');

@$core.Deprecated('Use getPersonDetailsResponseDescriptor instead')
const GetPersonDetailsResponse$json = {
  '1': 'GetPersonDetailsResponse',
  '2': [
    {
      '1': 'person',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.umbela.v1.PersonSummary',
      '10': 'person'
    },
    {
      '1': 'albums',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.umbela.v1.AlbumSummary',
      '10': 'albums'
    },
    {
      '1': 'places',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.umbela.v1.PlaceSummary',
      '10': 'places'
    },
    {
      '1': 'photos',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.umbela.v1.PhotoSummary',
      '10': 'photos'
    },
  ],
};

/// Descriptor for `GetPersonDetailsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPersonDetailsResponseDescriptor = $convert.base64Decode(
    'ChhHZXRQZXJzb25EZXRhaWxzUmVzcG9uc2USMAoGcGVyc29uGAEgASgLMhgudW1iZWxhLnYxLl'
    'BlcnNvblN1bW1hcnlSBnBlcnNvbhIvCgZhbGJ1bXMYAiADKAsyFy51bWJlbGEudjEuQWxidW1T'
    'dW1tYXJ5UgZhbGJ1bXMSLwoGcGxhY2VzGAMgAygLMhcudW1iZWxhLnYxLlBsYWNlU3VtbWFyeV'
    'IGcGxhY2VzEi8KBnBob3RvcxgEIAMoCzIXLnVtYmVsYS52MS5QaG90b1N1bW1hcnlSBnBob3Rv'
    'cw==');

@$core.Deprecated('Use listAlbumsRequestDescriptor instead')
const ListAlbumsRequest$json = {
  '1': 'ListAlbumsRequest',
};

/// Descriptor for `ListAlbumsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAlbumsRequestDescriptor =
    $convert.base64Decode('ChFMaXN0QWxidW1zUmVxdWVzdA==');

@$core.Deprecated('Use listAlbumsResponseDescriptor instead')
const ListAlbumsResponse$json = {
  '1': 'ListAlbumsResponse',
  '2': [
    {
      '1': 'albums',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.umbela.v1.AlbumSummary',
      '10': 'albums'
    },
  ],
};

/// Descriptor for `ListAlbumsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAlbumsResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0QWxidW1zUmVzcG9uc2USLwoGYWxidW1zGAEgAygLMhcudW1iZWxhLnYxLkFsYnVtU3'
    'VtbWFyeVIGYWxidW1z');

@$core.Deprecated('Use createAlbumRequestDescriptor instead')
const CreateAlbumRequest$json = {
  '1': 'CreateAlbumRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `CreateAlbumRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createAlbumRequestDescriptor = $convert
    .base64Decode('ChJDcmVhdGVBbGJ1bVJlcXVlc3QSEgoEbmFtZRgBIAEoCVIEbmFtZQ==');

@$core.Deprecated('Use createAlbumResponseDescriptor instead')
const CreateAlbumResponse$json = {
  '1': 'CreateAlbumResponse',
  '2': [
    {
      '1': 'album',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.umbela.v1.AlbumSummary',
      '10': 'album'
    },
  ],
};

/// Descriptor for `CreateAlbumResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createAlbumResponseDescriptor = $convert.base64Decode(
    'ChNDcmVhdGVBbGJ1bVJlc3BvbnNlEi0KBWFsYnVtGAEgASgLMhcudW1iZWxhLnYxLkFsYnVtU3'
    'VtbWFyeVIFYWxidW0=');

@$core.Deprecated('Use listPlacesRequestDescriptor instead')
const ListPlacesRequest$json = {
  '1': 'ListPlacesRequest',
};

/// Descriptor for `ListPlacesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPlacesRequestDescriptor =
    $convert.base64Decode('ChFMaXN0UGxhY2VzUmVxdWVzdA==');

@$core.Deprecated('Use listPlacesResponseDescriptor instead')
const ListPlacesResponse$json = {
  '1': 'ListPlacesResponse',
  '2': [
    {
      '1': 'places',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.umbela.v1.PlaceSummary',
      '10': 'places'
    },
  ],
};

/// Descriptor for `ListPlacesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPlacesResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0UGxhY2VzUmVzcG9uc2USLwoGcGxhY2VzGAEgAygLMhcudW1iZWxhLnYxLlBsYWNlU3'
    'VtbWFyeVIGcGxhY2Vz');

const $core.Map<$core.String, $core.dynamic> PhotoServiceBase$json = {
  '1': 'PhotoService',
  '2': [
    {
      '1': 'GetTimeline',
      '2': '.umbela.v1.GetTimelineRequest',
      '3': '.umbela.v1.GetTimelineResponse'
    },
    {
      '1': 'GetTimelineBuckets',
      '2': '.umbela.v1.GetTimelineBucketsRequest',
      '3': '.umbela.v1.GetTimelineBucketsResponse'
    },
    {
      '1': 'StreamThumbnail',
      '2': '.umbela.v1.GetThumbnailRequest',
      '3': '.umbela.v1.Chunk',
      '6': true
    },
    {
      '1': 'StreamFullImage',
      '2': '.umbela.v1.GetFullImageRequest',
      '3': '.umbela.v1.Chunk',
      '6': true
    },
    {
      '1': 'GetPhotoDetails',
      '2': '.umbela.v1.GetPhotoDetailsRequest',
      '3': '.umbela.v1.GetPhotoDetailsResponse'
    },
    {
      '1': 'ToggleFavorite',
      '2': '.umbela.v1.ToggleFavoriteRequest',
      '3': '.umbela.v1.ToggleFavoriteResponse'
    },
    {
      '1': 'DeletePhoto',
      '2': '.umbela.v1.DeletePhotoRequest',
      '3': '.umbela.v1.DeletePhotoResponse'
    },
    {
      '1': 'AddPhotoToAlbum',
      '2': '.umbela.v1.AddPhotoToAlbumRequest',
      '3': '.umbela.v1.AddPhotoToAlbumResponse'
    },
    {
      '1': 'ListPeople',
      '2': '.umbela.v1.ListPeopleRequest',
      '3': '.umbela.v1.ListPeopleResponse'
    },
    {
      '1': 'LabelPerson',
      '2': '.umbela.v1.LabelPersonRequest',
      '3': '.umbela.v1.LabelPersonResponse'
    },
    {
      '1': 'GetPersonDetails',
      '2': '.umbela.v1.GetPersonDetailsRequest',
      '3': '.umbela.v1.GetPersonDetailsResponse'
    },
    {
      '1': 'SetPersonCover',
      '2': '.umbela.v1.SetPersonCoverRequest',
      '3': '.umbela.v1.SetPersonCoverResponse'
    },
    {
      '1': 'ListAlbums',
      '2': '.umbela.v1.ListAlbumsRequest',
      '3': '.umbela.v1.ListAlbumsResponse'
    },
    {
      '1': 'CreateAlbum',
      '2': '.umbela.v1.CreateAlbumRequest',
      '3': '.umbela.v1.CreateAlbumResponse'
    },
    {
      '1': 'SetAlbumCover',
      '2': '.umbela.v1.SetAlbumCoverRequest',
      '3': '.umbela.v1.SetAlbumCoverResponse'
    },
    {
      '1': 'ListPlaces',
      '2': '.umbela.v1.ListPlacesRequest',
      '3': '.umbela.v1.ListPlacesResponse'
    },
  ],
};

@$core.Deprecated('Use photoServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    PhotoServiceBase$messageJson = {
  '.umbela.v1.GetTimelineRequest': GetTimelineRequest$json,
  '.umbela.v1.GetTimelineResponse': GetTimelineResponse$json,
  '.umbela.v1.PhotoSummary': PhotoSummary$json,
  '.umbela.v1.GetTimelineBucketsRequest': GetTimelineBucketsRequest$json,
  '.umbela.v1.GetTimelineBucketsResponse': GetTimelineBucketsResponse$json,
  '.umbela.v1.TimelineBucket': TimelineBucket$json,
  '.umbela.v1.GetThumbnailRequest': GetThumbnailRequest$json,
  '.umbela.v1.Chunk': Chunk$json,
  '.umbela.v1.GetFullImageRequest': GetFullImageRequest$json,
  '.umbela.v1.GetPhotoDetailsRequest': GetPhotoDetailsRequest$json,
  '.umbela.v1.GetPhotoDetailsResponse': GetPhotoDetailsResponse$json,
  '.umbela.v1.PhotoDetails': PhotoDetails$json,
  '.umbela.v1.FaceInPhoto': FaceInPhoto$json,
  '.umbela.v1.ToggleFavoriteRequest': ToggleFavoriteRequest$json,
  '.umbela.v1.ToggleFavoriteResponse': ToggleFavoriteResponse$json,
  '.umbela.v1.DeletePhotoRequest': DeletePhotoRequest$json,
  '.umbela.v1.DeletePhotoResponse': DeletePhotoResponse$json,
  '.umbela.v1.AddPhotoToAlbumRequest': AddPhotoToAlbumRequest$json,
  '.umbela.v1.AddPhotoToAlbumResponse': AddPhotoToAlbumResponse$json,
  '.umbela.v1.ListPeopleRequest': ListPeopleRequest$json,
  '.umbela.v1.ListPeopleResponse': ListPeopleResponse$json,
  '.umbela.v1.PersonSummary': PersonSummary$json,
  '.umbela.v1.LabelPersonRequest': LabelPersonRequest$json,
  '.umbela.v1.LabelPersonResponse': LabelPersonResponse$json,
  '.umbela.v1.GetPersonDetailsRequest': GetPersonDetailsRequest$json,
  '.umbela.v1.GetPersonDetailsResponse': GetPersonDetailsResponse$json,
  '.umbela.v1.AlbumSummary': AlbumSummary$json,
  '.umbela.v1.PlaceSummary': PlaceSummary$json,
  '.umbela.v1.SetPersonCoverRequest': SetPersonCoverRequest$json,
  '.umbela.v1.SetPersonCoverResponse': SetPersonCoverResponse$json,
  '.umbela.v1.ListAlbumsRequest': ListAlbumsRequest$json,
  '.umbela.v1.ListAlbumsResponse': ListAlbumsResponse$json,
  '.umbela.v1.CreateAlbumRequest': CreateAlbumRequest$json,
  '.umbela.v1.CreateAlbumResponse': CreateAlbumResponse$json,
  '.umbela.v1.SetAlbumCoverRequest': SetAlbumCoverRequest$json,
  '.umbela.v1.SetAlbumCoverResponse': SetAlbumCoverResponse$json,
  '.umbela.v1.ListPlacesRequest': ListPlacesRequest$json,
  '.umbela.v1.ListPlacesResponse': ListPlacesResponse$json,
};

/// Descriptor for `PhotoService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List photoServiceDescriptor = $convert.base64Decode(
    'CgxQaG90b1NlcnZpY2USTAoLR2V0VGltZWxpbmUSHS51bWJlbGEudjEuR2V0VGltZWxpbmVSZX'
    'F1ZXN0Gh4udW1iZWxhLnYxLkdldFRpbWVsaW5lUmVzcG9uc2USYQoSR2V0VGltZWxpbmVCdWNr'
    'ZXRzEiQudW1iZWxhLnYxLkdldFRpbWVsaW5lQnVja2V0c1JlcXVlc3QaJS51bWJlbGEudjEuR2'
    'V0VGltZWxpbmVCdWNrZXRzUmVzcG9uc2USRQoPU3RyZWFtVGh1bWJuYWlsEh4udW1iZWxhLnYx'
    'LkdldFRodW1ibmFpbFJlcXVlc3QaEC51bWJlbGEudjEuQ2h1bmswARJFCg9TdHJlYW1GdWxsSW'
    '1hZ2USHi51bWJlbGEudjEuR2V0RnVsbEltYWdlUmVxdWVzdBoQLnVtYmVsYS52MS5DaHVuazAB'
    'ElgKD0dldFBob3RvRGV0YWlscxIhLnVtYmVsYS52MS5HZXRQaG90b0RldGFpbHNSZXF1ZXN0Gi'
    'IudW1iZWxhLnYxLkdldFBob3RvRGV0YWlsc1Jlc3BvbnNlElUKDlRvZ2dsZUZhdm9yaXRlEiAu'
    'dW1iZWxhLnYxLlRvZ2dsZUZhdm9yaXRlUmVxdWVzdBohLnVtYmVsYS52MS5Ub2dnbGVGYXZvcm'
    'l0ZVJlc3BvbnNlEkwKC0RlbGV0ZVBob3RvEh0udW1iZWxhLnYxLkRlbGV0ZVBob3RvUmVxdWVz'
    'dBoeLnVtYmVsYS52MS5EZWxldGVQaG90b1Jlc3BvbnNlElgKD0FkZFBob3RvVG9BbGJ1bRIhLn'
    'VtYmVsYS52MS5BZGRQaG90b1RvQWxidW1SZXF1ZXN0GiIudW1iZWxhLnYxLkFkZFBob3RvVG9B'
    'bGJ1bVJlc3BvbnNlEkkKCkxpc3RQZW9wbGUSHC51bWJlbGEudjEuTGlzdFBlb3BsZVJlcXVlc3'
    'QaHS51bWJlbGEudjEuTGlzdFBlb3BsZVJlc3BvbnNlEkwKC0xhYmVsUGVyc29uEh0udW1iZWxh'
    'LnYxLkxhYmVsUGVyc29uUmVxdWVzdBoeLnVtYmVsYS52MS5MYWJlbFBlcnNvblJlc3BvbnNlEl'
    'sKEEdldFBlcnNvbkRldGFpbHMSIi51bWJlbGEudjEuR2V0UGVyc29uRGV0YWlsc1JlcXVlc3Qa'
    'Iy51bWJlbGEudjEuR2V0UGVyc29uRGV0YWlsc1Jlc3BvbnNlElUKDlNldFBlcnNvbkNvdmVyEi'
    'AudW1iZWxhLnYxLlNldFBlcnNvbkNvdmVyUmVxdWVzdBohLnVtYmVsYS52MS5TZXRQZXJzb25D'
    'b3ZlclJlc3BvbnNlEkkKCkxpc3RBbGJ1bXMSHC51bWJlbGEudjEuTGlzdEFsYnVtc1JlcXVlc3'
    'QaHS51bWJlbGEudjEuTGlzdEFsYnVtc1Jlc3BvbnNlEkwKC0NyZWF0ZUFsYnVtEh0udW1iZWxh'
    'LnYxLkNyZWF0ZUFsYnVtUmVxdWVzdBoeLnVtYmVsYS52MS5DcmVhdGVBbGJ1bVJlc3BvbnNlEl'
    'IKDVNldEFsYnVtQ292ZXISHy51bWJlbGEudjEuU2V0QWxidW1Db3ZlclJlcXVlc3QaIC51bWJl'
    'bGEudjEuU2V0QWxidW1Db3ZlclJlc3BvbnNlEkkKCkxpc3RQbGFjZXMSHC51bWJlbGEudjEuTG'
    'lzdFBsYWNlc1JlcXVlc3QaHS51bWJlbGEudjEuTGlzdFBsYWNlc1Jlc3BvbnNl');
