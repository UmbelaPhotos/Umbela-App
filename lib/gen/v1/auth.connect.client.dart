//
//  Generated code. Do not modify.
//  source: v1/auth.proto
//

import "package:connectrpc/connect.dart" as connect;

import "auth.pb.dart" as v1auth;
import "auth.connect.spec.dart" as specs;

extension type AuthServiceClient(connect.Transport _transport) {
  /// Prueba la posesión de la clave Ed25519 del servidor (QR)[cite: 11]
  Future<v1auth.IdentifyResponse> identify(
    v1auth.IdentifyRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AuthService.identify,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Entrega la KEK, desbloquea la RAM y genera el token de sesión[cite: 11]
  Future<v1auth.UnlockResponse> unlock(
    v1auth.UnlockRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AuthService.unlock,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Consulta el estado del Vault y la expiración del token
  Future<v1auth.GetStatusResponse> getStatus(
    v1auth.GetStatusRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AuthService.getStatus,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Fuerza el bloqueo inmediato del Vault y destruye tokens en RAM
  Future<v1auth.LockResponse> lock(
    v1auth.LockRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AuthService.lock,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
