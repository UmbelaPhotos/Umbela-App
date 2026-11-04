import 'dart:convert';
import 'dart:typed_data';

class PairingFormatException implements Exception {
  PairingFormatException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// What the server's QR carries:
/// `umbela://pair?onion=<host>.onion&port=<n>&salt=<b64url>&pk=<b64url>`.
/// Nothing here is secret: the KEK also needs the user's password.
class PairingData {
  PairingData({
    required this.onion,
    required this.port,
    required Uint8List salt,
    required Uint8List serverKey,
  }) : salt = Uint8List.fromList(salt),
       serverKey = Uint8List.fromList(serverKey);

  final String onion;
  final int port;

  /// Argon2id salt for the KEK (same one the server vault uses).
  final Uint8List salt;

  /// Ed25519 public key of the server, used to authenticate it.
  final Uint8List serverKey;

  String get baseUrl => 'http://$onion:$port';

  static final _onionV3 = RegExp(r'^[a-z2-7]{56}\.onion$');

  factory PairingData.parse(String raw) {
    final uri = Uri.tryParse(raw.trim());
    if (uri == null || uri.scheme != 'umbela' || uri.host != 'pair') {
      throw PairingFormatException('Este QR no es de un servidor Umbela.');
    }
    final q = uri.queryParameters;
    final onion = (q['onion'] ?? '').toLowerCase();
    if (!_onionV3.hasMatch(onion) && !_isDevHost(onion)) {
      throw PairingFormatException('Dirección .onion inválida.');
    }
    final port = int.tryParse(q['port'] ?? '');
    if (port == null || port < 1 || port > 65535) {
      throw PairingFormatException('Puerto inválido.');
    }
    final salt = _b64(q['salt'], 'salt');
    if (salt.length < 16) throw PairingFormatException('Salt demasiado corto.');
    final pk = _b64(q['pk'], 'clave pública');
    if (pk.length != 32) {
      throw PairingFormatException(
        'La clave pública debe ser Ed25519 (32 bytes).',
      );
    }
    return PairingData(onion: onion, port: port, salt: salt, serverKey: pk);
  }

  // Lets dev setups (e.g. a local test server) pair without a real onion.
  static bool _isDevHost(String h) => h == 'demo.onion' || h == 'localhost';

  static Uint8List _b64(String? v, String what) {
    if (v == null || v.isEmpty) throw PairingFormatException('Falta $what.');
    try {
      return Uint8List.fromList(base64Url.decode(base64Url.normalize(v)));
    } on FormatException {
      throw PairingFormatException('Valor inválido en $what.');
    }
  }

  String toJson() => jsonEncode({
    'onion': onion,
    'port': port,
    'salt': base64Encode(salt),
    'pk': base64Encode(serverKey),
  });

  factory PairingData.fromJson(String json) {
    final m = jsonDecode(json) as Map<String, dynamic>;
    return PairingData(
      onion: m['onion'] as String,
      port: m['port'] as int,
      salt: base64Decode(m['salt'] as String),
      serverKey: base64Decode(m['pk'] as String),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PairingData &&
      other.onion == onion &&
      other.port == port &&
      _eq(other.salt, salt) &&
      _eq(other.serverKey, serverKey);

  @override
  int get hashCode => Object.hash(onion, port, Object.hashAll(salt));

  static bool _eq(Uint8List a, Uint8List b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
