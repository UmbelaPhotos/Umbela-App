import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:umbela_app/core/security/kek_deriver.dart';
import 'package:umbela_app/core/security/pairing.dart';
import 'package:umbela_app/core/security/server_identity.dart';

String _b64u(List<int> b) => base64Url.encode(b).replaceAll('=', '');

void main() {
  test('KEK matches umbela-server DeriveKEK (Go reference vector)', () async {
    // Produced with internal/crypto.DeriveKEK("correct horse ñ", "0123456789abcdef").
    final kek = await const Argon2KekDeriver().derive(
      'correct horse ñ',
      Uint8List.fromList(utf8.encode('0123456789abcdef')),
    );
    final hex = kek.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    expect(
      hex,
      'c7d4477eed0529e4366383b73a6de83117e8e75cc1654a6f13385b29a2f5a8fc',
    );
  }, timeout: const Timeout(Duration(minutes: 3)));

  group('PairingData.parse', () {
    final onion = '${'a' * 56}.onion';
    final salt = _b64u(List.generate(16, (i) => i));
    final pk = _b64u(List.filled(32, 7));

    test('reads a valid QR', () {
      final d = PairingData.parse(
        'umbela://pair?onion=$onion&port=8080&salt=$salt&pk=$pk',
      );
      expect(d.onion, onion);
      expect(d.port, 8080);
      expect(d.salt.length, 16);
      expect(d.serverKey, List.filled(32, 7));
      expect(d.baseUrl, 'http://$onion:8080');
      expect(PairingData.fromJson(d.toJson()), d);
    });

    test('rejects foreign or malformed QRs', () {
      for (final bad in [
        'https://example.com',
        'allium://pair?onion=$onion&port=1&salt=$salt&pk=$pk',
        'umbela://pair?onion=nope.onion&port=1&salt=$salt&pk=$pk',
        'umbela://pair?onion=$onion&port=0&salt=$salt&pk=$pk',
        'umbela://pair?onion=$onion&port=1&salt=${_b64u([1, 2])}&pk=$pk',
        'umbela://pair?onion=$onion&port=1&salt=$salt&pk=${_b64u([1, 2])}',
        'umbela://pair?onion=$onion&port=1&pk=$pk',
      ]) {
        expect(
          () => PairingData.parse(bad),
          throwsA(isA<PairingFormatException>()),
          reason: bad,
        );
      }
    });
  });

  test('server identity: accepts the real key, rejects another', () async {
    final ed = Ed25519();
    final real = await ed.newKeyPair();
    final other = await ed.newKeyPair();
    final nonce = Uint8List.fromList(List.generate(32, (i) => i));
    final msg = [...utf8.encode(identifyContext), ...nonce];
    final sig = await ed.sign(msg, keyPair: real);

    Future<bool> check(SimpleKeyPair signer, SimpleKeyPair claimed) async =>
        verifyServerIdentity(
          serverKey: Uint8List.fromList(
            (await claimed.extractPublicKey()).bytes,
          ),
          nonce: nonce,
          signature: Uint8List.fromList(sig.bytes),
        );

    expect(await check(real, real), isTrue);
    expect(await check(real, other), isFalse);
  });
}
