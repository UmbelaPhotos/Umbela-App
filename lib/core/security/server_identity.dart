import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

const identifyContext = 'umbela-identify-v1';

/// True when [signature] is the server's Ed25519 signature of
/// `"umbela-identify-v1" || nonce` under the key from the pairing QR.
Future<bool> verifyServerIdentity({
  required Uint8List serverKey,
  required Uint8List nonce,
  required Uint8List signature,
}) {
  final message = Uint8List.fromList([
    ...utf8.encode(identifyContext),
    ...nonce,
  ]);
  return Ed25519().verify(
    message,
    signature: Signature(
      signature,
      publicKey: SimplePublicKey(serverKey, type: KeyPairType.ed25519),
    ),
  );
}
