# umbela_app

Cliente Flutter de Umbela (fototeca privada, self-hosted, sobre Tor).

## Modelo de acceso
- El QR de `umbela pair` trae `umbela://pair?onion=<host>.onion&port=<n>&salt=<b64url>&pk=<b64url>` (pk = clave pública Ed25519 del servidor).
- Único input del usuario: la contraseña. `KEK = Argon2id(contraseña, salt)` (t=3, m=64 MiB, p=4, 32 B; igual que `DeriveKEK` en Go, con vector de prueba en `test/security_test.dart`).
- Antes de enviar la KEK, la app llama `Identify` y verifica la firma Ed25519 con la clave del QR.
- `Unlock(kek)` se llama una vez; el servidor devuelve un `session_token` (solo RAM) que se manda como `Bearer` y evita volver a exponer la KEK. Si el servidor responde `unauthenticated`, se vuelve a hacer `Unlock`.
- Switch de biometría: ON = KEK tras biometría de hardware, se pide cada vez y la app se bloquea al salir; OFF = KEK guardada sin biometría, la app no se bloquea.

## Desarrollo
- Contrato Connect: `proto/v1`. Regenerar: `protoc -I proto --dart_out=lib/gen --connect-dart_out=lib/gen proto/v1/*.proto` (necesita `protoc-gen-dart` de `protoc_plugin` y `protoc-gen-connect-dart` del paquete `connectrpc` en el PATH).
- Por defecto usa datos mock y el botón de QR empareja un servidor de demostración: `flutter run`. Servidor real: `--dart-define=USE_MOCK=false`.
- Tor: cliente embebido (paquete `tor`, requiere Rust + cargo-ndk). En emulador: `--dart-define=TOR_EXTERNAL=true` con un SOCKS5 en 127.0.0.1:9050.
- Transporte: Connect sobre HTTP/1.1 plano dentro del onion, con `dart:io` HttpClient + túnel SOCKS5 (el nombre .onion lo resuelve Tor).
