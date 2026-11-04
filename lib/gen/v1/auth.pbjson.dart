// This is a generated file - do not edit.
//
// Generated from v1/auth.proto.

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

@$core.Deprecated('Use identifyRequestDescriptor instead')
const IdentifyRequest$json = {
  '1': 'IdentifyRequest',
  '2': [
    {'1': 'nonce', '3': 1, '4': 1, '5': 12, '10': 'nonce'},
  ],
};

/// Descriptor for `IdentifyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List identifyRequestDescriptor = $convert
    .base64Decode('Cg9JZGVudGlmeVJlcXVlc3QSFAoFbm9uY2UYASABKAxSBW5vbmNl');

@$core.Deprecated('Use identifyResponseDescriptor instead')
const IdentifyResponse$json = {
  '1': 'IdentifyResponse',
  '2': [
    {'1': 'signature', '3': 1, '4': 1, '5': 12, '10': 'signature'},
  ],
};

/// Descriptor for `IdentifyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List identifyResponseDescriptor = $convert.base64Decode(
    'ChBJZGVudGlmeVJlc3BvbnNlEhwKCXNpZ25hdHVyZRgBIAEoDFIJc2lnbmF0dXJl');

@$core.Deprecated('Use unlockRequestDescriptor instead')
const UnlockRequest$json = {
  '1': 'UnlockRequest',
  '2': [
    {'1': 'kek', '3': 1, '4': 1, '5': 12, '10': 'kek'},
  ],
};

/// Descriptor for `UnlockRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unlockRequestDescriptor =
    $convert.base64Decode('Cg1VbmxvY2tSZXF1ZXN0EhAKA2tlaxgBIAEoDFIDa2Vr');

@$core.Deprecated('Use unlockResponseDescriptor instead')
const UnlockResponse$json = {
  '1': 'UnlockResponse',
  '2': [
    {'1': 'session_token', '3': 1, '4': 1, '5': 9, '10': 'sessionToken'},
    {'1': 'expires_at_unix', '3': 2, '4': 1, '5': 3, '10': 'expiresAtUnix'},
  ],
};

/// Descriptor for `UnlockResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unlockResponseDescriptor = $convert.base64Decode(
    'Cg5VbmxvY2tSZXNwb25zZRIjCg1zZXNzaW9uX3Rva2VuGAEgASgJUgxzZXNzaW9uVG9rZW4SJg'
    'oPZXhwaXJlc19hdF91bml4GAIgASgDUg1leHBpcmVzQXRVbml4');

@$core.Deprecated('Use getStatusRequestDescriptor instead')
const GetStatusRequest$json = {
  '1': 'GetStatusRequest',
};

/// Descriptor for `GetStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStatusRequestDescriptor =
    $convert.base64Decode('ChBHZXRTdGF0dXNSZXF1ZXN0');

@$core.Deprecated('Use getStatusResponseDescriptor instead')
const GetStatusResponse$json = {
  '1': 'GetStatusResponse',
  '2': [
    {'1': 'is_unlocked', '3': 1, '4': 1, '5': 8, '10': 'isUnlocked'},
    {'1': 'expires_at_unix', '3': 2, '4': 1, '5': 3, '10': 'expiresAtUnix'},
  ],
};

/// Descriptor for `GetStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStatusResponseDescriptor = $convert.base64Decode(
    'ChFHZXRTdGF0dXNSZXNwb25zZRIfCgtpc191bmxvY2tlZBgBIAEoCFIKaXNVbmxvY2tlZBImCg'
    '9leHBpcmVzX2F0X3VuaXgYAiABKANSDWV4cGlyZXNBdFVuaXg=');

@$core.Deprecated('Use lockRequestDescriptor instead')
const LockRequest$json = {
  '1': 'LockRequest',
};

/// Descriptor for `LockRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lockRequestDescriptor =
    $convert.base64Decode('CgtMb2NrUmVxdWVzdA==');

@$core.Deprecated('Use lockResponseDescriptor instead')
const LockResponse$json = {
  '1': 'LockResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `LockResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lockResponseDescriptor = $convert
    .base64Decode('CgxMb2NrUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcw==');

const $core.Map<$core.String, $core.dynamic> AuthServiceBase$json = {
  '1': 'AuthService',
  '2': [
    {
      '1': 'Identify',
      '2': '.umbela.v1.IdentifyRequest',
      '3': '.umbela.v1.IdentifyResponse'
    },
    {
      '1': 'Unlock',
      '2': '.umbela.v1.UnlockRequest',
      '3': '.umbela.v1.UnlockResponse'
    },
    {
      '1': 'GetStatus',
      '2': '.umbela.v1.GetStatusRequest',
      '3': '.umbela.v1.GetStatusResponse'
    },
    {
      '1': 'Lock',
      '2': '.umbela.v1.LockRequest',
      '3': '.umbela.v1.LockResponse'
    },
  ],
};

@$core.Deprecated('Use authServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    AuthServiceBase$messageJson = {
  '.umbela.v1.IdentifyRequest': IdentifyRequest$json,
  '.umbela.v1.IdentifyResponse': IdentifyResponse$json,
  '.umbela.v1.UnlockRequest': UnlockRequest$json,
  '.umbela.v1.UnlockResponse': UnlockResponse$json,
  '.umbela.v1.GetStatusRequest': GetStatusRequest$json,
  '.umbela.v1.GetStatusResponse': GetStatusResponse$json,
  '.umbela.v1.LockRequest': LockRequest$json,
  '.umbela.v1.LockResponse': LockResponse$json,
};

/// Descriptor for `AuthService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List authServiceDescriptor = $convert.base64Decode(
    'CgtBdXRoU2VydmljZRJDCghJZGVudGlmeRIaLnVtYmVsYS52MS5JZGVudGlmeVJlcXVlc3QaGy'
    '51bWJlbGEudjEuSWRlbnRpZnlSZXNwb25zZRI9CgZVbmxvY2sSGC51bWJlbGEudjEuVW5sb2Nr'
    'UmVxdWVzdBoZLnVtYmVsYS52MS5VbmxvY2tSZXNwb25zZRJGCglHZXRTdGF0dXMSGy51bWJlbG'
    'EudjEuR2V0U3RhdHVzUmVxdWVzdBocLnVtYmVsYS52MS5HZXRTdGF0dXNSZXNwb25zZRI3CgRM'
    'b2NrEhYudW1iZWxhLnYxLkxvY2tSZXF1ZXN0GhcudW1iZWxhLnYxLkxvY2tSZXNwb25zZQ==');
