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

import 'package:protobuf/protobuf.dart' as $pb;

import 'auth.pb.dart' as $0;
import 'auth.pbjson.dart';

export 'auth.pb.dart';

abstract class AuthServiceBase extends $pb.GeneratedService {
  $async.Future<$0.IdentifyResponse> identify(
      $pb.ServerContext ctx, $0.IdentifyRequest request);
  $async.Future<$0.UnlockResponse> unlock(
      $pb.ServerContext ctx, $0.UnlockRequest request);
  $async.Future<$0.GetStatusResponse> getStatus(
      $pb.ServerContext ctx, $0.GetStatusRequest request);
  $async.Future<$0.LockResponse> lock(
      $pb.ServerContext ctx, $0.LockRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'Identify':
        return $0.IdentifyRequest();
      case 'Unlock':
        return $0.UnlockRequest();
      case 'GetStatus':
        return $0.GetStatusRequest();
      case 'Lock':
        return $0.LockRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'Identify':
        return identify(ctx, request as $0.IdentifyRequest);
      case 'Unlock':
        return unlock(ctx, request as $0.UnlockRequest);
      case 'GetStatus':
        return getStatus(ctx, request as $0.GetStatusRequest);
      case 'Lock':
        return lock(ctx, request as $0.LockRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => AuthServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => AuthServiceBase$messageJson;
}
