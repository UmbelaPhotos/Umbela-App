// This is a generated file - do not edit.
//
// Generated from v1/auth.proto.

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

class IdentifyRequest extends $pb.GeneratedMessage {
  factory IdentifyRequest({
    $core.List<$core.int>? nonce,
  }) {
    final result = IdentifyRequest._();
    if (nonce != null) result.nonce = nonce;
    return result;
  }

  IdentifyRequest._();

  factory IdentifyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdentifyRequest()..mergeFromBuffer(data, registry);
  factory IdentifyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdentifyRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdentifyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: IdentifyRequest.$_createMessage)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'nonce', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdentifyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdentifyRequest copyWith(void Function(IdentifyRequest) updates) =>
      super.copyWith((message) => updates(message as IdentifyRequest))
          as IdentifyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use IdentifyRequest() / IdentifyRequest.new instead')
  static IdentifyRequest create() => IdentifyRequest._();
  static $pb.GeneratedMessage $_createMessage() => IdentifyRequest._();
  @$core.override
  IdentifyRequest createEmptyInstance() => IdentifyRequest._();
  @$core.pragma('dart2js:noInline')
  static IdentifyRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IdentifyRequest>(
          IdentifyRequest.$_createMessage);
  static IdentifyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get nonce => $_getN(0);
  @$pb.TagNumber(1)
  set nonce($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNonce() => $_has(0);
  @$pb.TagNumber(1)
  void clearNonce() => $_clearField(1);
}

class IdentifyResponse extends $pb.GeneratedMessage {
  factory IdentifyResponse({
    $core.List<$core.int>? signature,
  }) {
    final result = IdentifyResponse._();
    if (signature != null) result.signature = signature;
    return result;
  }

  IdentifyResponse._();

  factory IdentifyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdentifyResponse()..mergeFromBuffer(data, registry);
  factory IdentifyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdentifyResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdentifyResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: IdentifyResponse.$_createMessage)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'signature', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdentifyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdentifyResponse copyWith(void Function(IdentifyResponse) updates) =>
      super.copyWith((message) => updates(message as IdentifyResponse))
          as IdentifyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use IdentifyResponse() / IdentifyResponse.new instead')
  static IdentifyResponse create() => IdentifyResponse._();
  static $pb.GeneratedMessage $_createMessage() => IdentifyResponse._();
  @$core.override
  IdentifyResponse createEmptyInstance() => IdentifyResponse._();
  @$core.pragma('dart2js:noInline')
  static IdentifyResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IdentifyResponse>(
          IdentifyResponse.$_createMessage);
  static IdentifyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get signature => $_getN(0);
  @$pb.TagNumber(1)
  set signature($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSignature() => $_has(0);
  @$pb.TagNumber(1)
  void clearSignature() => $_clearField(1);
}

class UnlockRequest extends $pb.GeneratedMessage {
  factory UnlockRequest({
    $core.List<$core.int>? kek,
  }) {
    final result = UnlockRequest._();
    if (kek != null) result.kek = kek;
    return result;
  }

  UnlockRequest._();

  factory UnlockRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UnlockRequest()..mergeFromBuffer(data, registry);
  factory UnlockRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UnlockRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnlockRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: UnlockRequest.$_createMessage)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'kek', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnlockRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnlockRequest copyWith(void Function(UnlockRequest) updates) =>
      super.copyWith((message) => updates(message as UnlockRequest))
          as UnlockRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UnlockRequest() / UnlockRequest.new instead')
  static UnlockRequest create() => UnlockRequest._();
  static $pb.GeneratedMessage $_createMessage() => UnlockRequest._();
  @$core.override
  UnlockRequest createEmptyInstance() => UnlockRequest._();
  @$core.pragma('dart2js:noInline')
  static UnlockRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnlockRequest>(
          UnlockRequest.$_createMessage);
  static UnlockRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get kek => $_getN(0);
  @$pb.TagNumber(1)
  set kek($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKek() => $_has(0);
  @$pb.TagNumber(1)
  void clearKek() => $_clearField(1);
}

class UnlockResponse extends $pb.GeneratedMessage {
  factory UnlockResponse({
    $core.String? sessionToken,
    $fixnum.Int64? expiresAtUnix,
  }) {
    final result = UnlockResponse._();
    if (sessionToken != null) result.sessionToken = sessionToken;
    if (expiresAtUnix != null) result.expiresAtUnix = expiresAtUnix;
    return result;
  }

  UnlockResponse._();

  factory UnlockResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UnlockResponse()..mergeFromBuffer(data, registry);
  factory UnlockResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UnlockResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnlockResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: UnlockResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'sessionToken')
    ..aInt64(2, _omitFieldNames ? '' : 'expiresAtUnix')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnlockResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnlockResponse copyWith(void Function(UnlockResponse) updates) =>
      super.copyWith((message) => updates(message as UnlockResponse))
          as UnlockResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UnlockResponse() / UnlockResponse.new instead')
  static UnlockResponse create() => UnlockResponse._();
  static $pb.GeneratedMessage $_createMessage() => UnlockResponse._();
  @$core.override
  UnlockResponse createEmptyInstance() => UnlockResponse._();
  @$core.pragma('dart2js:noInline')
  static UnlockResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnlockResponse>(
          UnlockResponse.$_createMessage);
  static UnlockResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionToken() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get expiresAtUnix => $_getI64(1);
  @$pb.TagNumber(2)
  set expiresAtUnix($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpiresAtUnix() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpiresAtUnix() => $_clearField(2);
}

class GetStatusRequest extends $pb.GeneratedMessage {
  factory GetStatusRequest() => GetStatusRequest._();

  GetStatusRequest._();

  factory GetStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetStatusRequest()..mergeFromBuffer(data, registry);
  factory GetStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetStatusRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStatusRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: GetStatusRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatusRequest copyWith(void Function(GetStatusRequest) updates) =>
      super.copyWith((message) => updates(message as GetStatusRequest))
          as GetStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetStatusRequest() / GetStatusRequest.new instead')
  static GetStatusRequest create() => GetStatusRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetStatusRequest._();
  @$core.override
  GetStatusRequest createEmptyInstance() => GetStatusRequest._();
  @$core.pragma('dart2js:noInline')
  static GetStatusRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetStatusRequest>(
          GetStatusRequest.$_createMessage);
  static GetStatusRequest? _defaultInstance;
}

class GetStatusResponse extends $pb.GeneratedMessage {
  factory GetStatusResponse({
    $core.bool? isUnlocked,
    $fixnum.Int64? expiresAtUnix,
  }) {
    final result = GetStatusResponse._();
    if (isUnlocked != null) result.isUnlocked = isUnlocked;
    if (expiresAtUnix != null) result.expiresAtUnix = expiresAtUnix;
    return result;
  }

  GetStatusResponse._();

  factory GetStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetStatusResponse()..mergeFromBuffer(data, registry);
  factory GetStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetStatusResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStatusResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: GetStatusResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'isUnlocked')
    ..aInt64(2, _omitFieldNames ? '' : 'expiresAtUnix')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatusResponse copyWith(void Function(GetStatusResponse) updates) =>
      super.copyWith((message) => updates(message as GetStatusResponse))
          as GetStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetStatusResponse() / GetStatusResponse.new instead')
  static GetStatusResponse create() => GetStatusResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetStatusResponse._();
  @$core.override
  GetStatusResponse createEmptyInstance() => GetStatusResponse._();
  @$core.pragma('dart2js:noInline')
  static GetStatusResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetStatusResponse>(
          GetStatusResponse.$_createMessage);
  static GetStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isUnlocked => $_getBF(0);
  @$pb.TagNumber(1)
  set isUnlocked($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsUnlocked() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsUnlocked() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get expiresAtUnix => $_getI64(1);
  @$pb.TagNumber(2)
  set expiresAtUnix($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpiresAtUnix() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpiresAtUnix() => $_clearField(2);
}

class LockRequest extends $pb.GeneratedMessage {
  factory LockRequest() => LockRequest._();

  LockRequest._();

  factory LockRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LockRequest()..mergeFromBuffer(data, registry);
  factory LockRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LockRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LockRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: LockRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LockRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LockRequest copyWith(void Function(LockRequest) updates) =>
      super.copyWith((message) => updates(message as LockRequest))
          as LockRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LockRequest() / LockRequest.new instead')
  static LockRequest create() => LockRequest._();
  static $pb.GeneratedMessage $_createMessage() => LockRequest._();
  @$core.override
  LockRequest createEmptyInstance() => LockRequest._();
  @$core.pragma('dart2js:noInline')
  static LockRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LockRequest>(
          LockRequest.$_createMessage);
  static LockRequest? _defaultInstance;
}

class LockResponse extends $pb.GeneratedMessage {
  factory LockResponse({
    $core.bool? success,
  }) {
    final result = LockResponse._();
    if (success != null) result.success = success;
    return result;
  }

  LockResponse._();

  factory LockResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LockResponse()..mergeFromBuffer(data, registry);
  factory LockResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LockResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LockResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'umbela.v1'),
      createEmptyInstance: LockResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LockResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LockResponse copyWith(void Function(LockResponse) updates) =>
      super.copyWith((message) => updates(message as LockResponse))
          as LockResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LockResponse() / LockResponse.new instead')
  static LockResponse create() => LockResponse._();
  static $pb.GeneratedMessage $_createMessage() => LockResponse._();
  @$core.override
  LockResponse createEmptyInstance() => LockResponse._();
  @$core.pragma('dart2js:noInline')
  static LockResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LockResponse>(
          LockResponse.$_createMessage);
  static LockResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class AuthServiceApi {
  final $pb.RpcClient _client;

  AuthServiceApi(this._client);

  /// Prueba la posesión de la clave Ed25519 del servidor (QR)[cite: 11]
  $async.Future<IdentifyResponse> identify(
          $pb.ClientContext? ctx, IdentifyRequest request) =>
      _client.invoke<IdentifyResponse>(
          ctx, 'AuthService', 'Identify', request, IdentifyResponse());

  /// Entrega la KEK, desbloquea la RAM y genera el token de sesión[cite: 11]
  $async.Future<UnlockResponse> unlock(
          $pb.ClientContext? ctx, UnlockRequest request) =>
      _client.invoke<UnlockResponse>(
          ctx, 'AuthService', 'Unlock', request, UnlockResponse());

  /// Consulta el estado del Vault y la expiración del token
  $async.Future<GetStatusResponse> getStatus(
          $pb.ClientContext? ctx, GetStatusRequest request) =>
      _client.invoke<GetStatusResponse>(
          ctx, 'AuthService', 'GetStatus', request, GetStatusResponse());

  /// Fuerza el bloqueo inmediato del Vault y destruye tokens en RAM
  $async.Future<LockResponse> lock(
          $pb.ClientContext? ctx, LockRequest request) =>
      _client.invoke<LockResponse>(
          ctx, 'AuthService', 'Lock', request, LockResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
