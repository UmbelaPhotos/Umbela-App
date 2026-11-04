import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

/// Derives the vault KEK from the user's password. Must match `DeriveKEK` in
/// umbela-server/internal/crypto/argon2.go.
abstract class KekDeriver {
  Future<Uint8List> derive(String password, Uint8List salt);
}

class Argon2KekDeriver implements KekDeriver {
  const Argon2KekDeriver();

  // time=3, memory=64 MiB (in 1 KiB blocks), threads=4, 32-byte key.
  static const iterations = 3;
  static const memoryKiB = 64 * 1024;
  static const parallelism = 4;
  static const length = 32;

  @override
  Future<Uint8List> derive(String password, Uint8List salt) {
    final pw = Uint8List.fromList(utf8.encode(password));
    // 64 MiB of Argon2 in pure Dart is heavy: keep it off the UI isolate.
    return Isolate.run(() async {
      final algo = Argon2id(
        parallelism: parallelism,
        memory: memoryKiB,
        iterations: iterations,
        hashLength: length,
      );
      final key = await algo.deriveKey(secretKey: SecretKey(pw), nonce: salt);
      return Uint8List.fromList(await key.extractBytes());
    });
  }
}
