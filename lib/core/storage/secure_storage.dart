import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../security/pairing.dart';

/// Non-secret pairing data plus the two security flags. Kept in the
/// Keychain/Keystore anyway.
class SecureStore {
  SecureStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _pairingKey = 'pairing';
  static const _biometricKey = 'biometric';
  static const _kekStoredKey = 'kek_stored';

  Future<PairingData?> readPairing() async {
    try {
      final raw = await _storage.read(key: _pairingKey);
      return raw == null ? null : PairingData.fromJson(raw);
    } catch (_) {
      return null;
    }
  }

  Future<void> savePairing(PairingData data) =>
      _storage.write(key: _pairingKey, value: data.toJson());

  /// Defaults to true: biometrics unless the user turned it off.
  Future<bool> readBiometric() async {
    try {
      return await _storage.read(key: _biometricKey) != 'false';
    } catch (_) {
      return true;
    }
  }

  Future<void> saveBiometric(bool value) =>
      _storage.write(key: _biometricKey, value: '$value');

  Future<bool> readKekStored() async {
    try {
      return await _storage.read(key: _kekStoredKey) == 'true';
    } catch (_) {
      return false;
    }
  }

  Future<void> saveKekStored(bool value) =>
      _storage.write(key: _kekStoredKey, value: '$value');

  Future<void> clear() async {
    for (final k in [_pairingKey, _biometricKey, _kekStoredKey]) {
      try {
        await _storage.delete(key: k);
      } catch (_) {}
    }
  }
}

/// Where the KEK lives on the phone.
///
/// With [biometric] true it is bound to the device's biometrics by hardware
/// (Android Keystore / iOS Keychain access control), so reading it prompts the
/// user. With false it sits in the regular secure storage and reads silently.
abstract class KekVault {
  Future<void> write(Uint8List kek, {required bool biometric});

  /// Null when nothing is stored. May show the biometric prompt.
  Future<Uint8List?> read({required bool biometric});

  Future<void> delete();
}

class FlutterKekVault implements KekVault {
  FlutterKekVault();

  static const _key = 'kek';

  final _plain = const FlutterSecureStorage();
  final _bio = const FlutterSecureStorage(
    aOptions: AndroidOptions.biometric(
      enforceBiometrics: true,
      requireBiometricsPerOperation: true,
      storageNamespace: 'umbela_kek_bio',
      biometricPromptTitle: 'Desbloquear Umbela',
      biometricPromptSubtitle: 'Confirma tu identidad para abrir tu fototeca',
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.passcode,
      accessControlFlags: [AccessControlFlag.biometryCurrentSet],
    ),
  );

  FlutterSecureStorage _for(bool biometric) => biometric ? _bio : _plain;

  @override
  Future<void> write(Uint8List kek, {required bool biometric}) async {
    // One copy only: remove the other storage's entry.
    await _for(!biometric).delete(key: _key);
    await _for(biometric).write(key: _key, value: base64Encode(kek));
  }

  @override
  Future<Uint8List?> read({required bool biometric}) async {
    final raw = await _for(biometric).read(key: _key);
    return raw == null ? null : Uint8List.fromList(base64Decode(raw));
  }

  @override
  Future<void> delete() async {
    for (final s in [_plain, _bio]) {
      try {
        await s.delete(key: _key);
      } catch (_) {}
    }
  }
}
