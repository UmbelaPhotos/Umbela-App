//
//  Generated code. Do not modify.
//  source: v1/auth.proto
//

import "package:connectrpc/connect.dart" as connect;

import "auth.pb.dart" as v1auth;

abstract final class AuthService {
  /// Fully-qualified name of the AuthService service.
  static const name = 'umbela.v1.AuthService';

  /// Prueba la posesión de la clave Ed25519 del servidor (QR)[cite: 11]
  static const identify = connect.Spec(
    '/$name/Identify',
    connect.StreamType.unary,
    v1auth.IdentifyRequest.new,
    v1auth.IdentifyResponse.new,
  );

  /// Entrega la KEK, desbloquea la RAM y genera el token de sesión[cite: 11]
  static const unlock = connect.Spec(
    '/$name/Unlock',
    connect.StreamType.unary,
    v1auth.UnlockRequest.new,
    v1auth.UnlockResponse.new,
  );

  /// Consulta el estado del Vault y la expiración del token
  static const getStatus = connect.Spec(
    '/$name/GetStatus',
    connect.StreamType.unary,
    v1auth.GetStatusRequest.new,
    v1auth.GetStatusResponse.new,
  );

  /// Fuerza el bloqueo inmediato del Vault y destruye tokens en RAM
  static const lock = connect.Spec(
    '/$name/Lock',
    connect.StreamType.unary,
    v1auth.LockRequest.new,
    v1auth.LockResponse.new,
  );
}
