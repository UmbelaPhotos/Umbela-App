import 'dart:typed_data';

import 'package:connectrpc/connect.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/connect_repositories.dart';
import '../../../core/providers.dart';
import '../../../core/security/pairing.dart';
import '../../../core/security/security_controller.dart';

class LoginException implements Exception {
  LoginException(this.message);
  final String message;
  @override
  String toString() => message;
}

class LoginController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// First unlock, or any unlock with the password typed in.
  Future<void> login(String password, {required bool biometric}) async {
    if (password.isEmpty) {
      state = AsyncError(
        LoginException('Escribe tu contraseña.'),
        StackTrace.current,
      );
      return;
    }
    final pairing = await _pairing();
    if (pairing == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final kek = await ref
          .read(kekDeriverProvider)
          .derive(password, pairing.salt);
      try {
        await _unlock(pairing, kek);
        // Only a KEK the server accepted is worth keeping.
        await ref
            .read(securityProvider.notifier)
            .storeKek(kek, biometric: biometric);
      } finally {
        kek.fillRange(0, kek.length, 0);
      }
    });
  }

  /// Unlock with the KEK kept on the phone (biometric prompt if enabled).
  Future<void> unlockStored() async {
    final pairing = await _pairing(silent: true);
    if (pairing == null) return;
    final security = ref.read(securityProvider.notifier);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final Uint8List? kek;
      try {
        kek = await security.readKek();
      } catch (_) {
        throw LoginException('No se pudo confirmar tu identidad.');
      }
      if (kek == null) {
        await security.forgetKek();
        throw LoginException('Escribe tu contraseña.');
      }
      // The phone has vouched for the user (biometrics, or nothing when they
      // are off): open the app on the cached timeline now, and let Tor and
      // the server catch up behind it.
      final pending = ref.read(pendingUnlockProvider.notifier)..set(true);
      try {
        await _unlock(pairing, kek, stored: true);
      } catch (_) {
        pending.set(false);
        rethrow;
      } finally {
        kek.fillRange(0, kek.length, 0);
      }
    });
  }

  Future<PairingData?> _pairing({bool silent = false}) async {
    final s = await ref.read(securityProvider.future);
    if (s.pairing == null && !silent) {
      state = AsyncError(
        LoginException('Vincula tu servidor escaneando el QR.'),
        StackTrace.current,
      );
    }
    return s.pairing;
  }

  Future<void> _unlock(
    PairingData pairing,
    Uint8List kek, {
    bool stored = false,
  }) async {
    try {
      await ref.read(torProxyProvider).start();
      final res = await ref
          .read(authRepositoryProvider)
          .unlock(server: pairing, kek: kek);
      // The user locked the app (or backed out) while Tor was starting.
      if (stored && !ref.read(pendingUnlockProvider)) return;
      // Setting the token lets the router in.
      ref.read(sessionTokenProvider.notifier).set(res.sessionToken);
      ref.read(pendingUnlockProvider.notifier).set(false);
    } on ConnectException catch (e) {
      if (e.code == Code.unauthenticated || e.code == Code.permissionDenied) {
        if (stored) await ref.read(securityProvider.notifier).forgetKek();
        throw LoginException(
          stored
              ? 'La contraseña cambió. Escríbela de nuevo.'
              : 'Contraseña incorrecta.',
        );
      }
      throw LoginException('El servidor no respondió: ${e.message}');
    } on ServerIdentityException catch (e) {
      throw LoginException(e.toString());
    }
  }
}

final loginControllerProvider = AsyncNotifierProvider<LoginController, void>(
  LoginController.new,
);
