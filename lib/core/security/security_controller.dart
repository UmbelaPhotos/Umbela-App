import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'pairing.dart';

class SecurityState {
  const SecurityState({
    this.pairing,
    this.biometric = true,
    this.kekStored = false,
  });

  final PairingData? pairing;

  /// ON: KEK behind biometrics, asked every time, app locks in background.
  /// OFF: KEK stored without biometrics, never locks.
  final bool biometric;
  final bool kekStored;

  SecurityState copyWith({
    PairingData? pairing,
    bool? biometric,
    bool? kekStored,
  }) => SecurityState(
    pairing: pairing ?? this.pairing,
    biometric: biometric ?? this.biometric,
    kekStored: kekStored ?? this.kekStored,
  );
}

class SecurityController extends AsyncNotifier<SecurityState> {
  @override
  Future<SecurityState> build() async {
    final store = ref.read(secureStoreProvider);
    return SecurityState(
      pairing: await store.readPairing(),
      biometric: await store.readBiometric(),
      kekStored: await store.readKekStored(),
    );
  }

  SecurityState get _s => state.value ?? const SecurityState();

  Future<void> pair(PairingData data) async {
    final previous = _s.pairing;
    // A different server means the old KEK is useless.
    if (previous != null && previous != data) await _forgetKek();
    await ref.read(secureStoreProvider).savePairing(data);
    state = AsyncData(
      _s.copyWith(pairing: data, kekStored: previous == data ? null : false),
    );
  }

  Future<void> storeKek(Uint8List kek, {required bool biometric}) async {
    await ref.read(kekVaultProvider).write(kek, biometric: biometric);
    final store = ref.read(secureStoreProvider);
    await store.saveBiometric(biometric);
    await store.saveKekStored(true);
    state = AsyncData(_s.copyWith(biometric: biometric, kekStored: true));
  }

  /// Moves the stored KEK between biometric and plain storage.
  Future<void> setBiometric(bool value) async {
    if (value == _s.biometric) return;
    final vault = ref.read(kekVaultProvider);
    if (_s.kekStored) {
      final kek = await vault.read(biometric: _s.biometric);
      if (kek != null) {
        await vault.write(kek, biometric: value);
        kek.fillRange(0, kek.length, 0);
      }
    }
    await ref.read(secureStoreProvider).saveBiometric(value);
    state = AsyncData(_s.copyWith(biometric: value));
  }

  Future<Uint8List?> readKek() =>
      ref.read(kekVaultProvider).read(biometric: _s.biometric);

  /// The stored KEK no longer opens the server (e.g. password changed).
  Future<void> forgetKek() => _forgetKek();

  Future<void> _forgetKek() async {
    await ref.read(kekVaultProvider).delete();
    await ref.read(secureStoreProvider).saveKekStored(false);
    state = AsyncData(_s.copyWith(kekStored: false));
  }

  Future<void> unlink() async {
    await ref.read(kekVaultProvider).delete();
    await ref.read(secureStoreProvider).clear();
    await ref.read(timelineCacheProvider).clear();
    state = const AsyncData(SecurityState());
  }
}

final securityProvider =
    AsyncNotifierProvider<SecurityController, SecurityState>(
      SecurityController.new,
    );
