# Arquitectura de umbela_app

Guía de cada carpeta y de cómo está organizado el código. Para el modelo de
seguridad y los comandos de compilación ver también el [README](README.md).

## Idea general

La app es un cliente Flutter de una fototeca privada que vive en tu propio
servidor. Se organiza **por funcionalidad** (*feature-first*): cada pantalla
agrupa su código, y lo que comparten varias pantallas va en `core/`.

```
Pantalla (features/*)  ──lee──▶  Providers (core/providers.dart)
                                      │
                                      ▼
                          Repositorios (core/data)
                           ├─ Mock      (datos de ejemplo, por defecto)
                           └─ Connect   (servidor real, USE_MOCK=false)
                                      │
                                      ▼
                       Cliente Connect (core/network)
                       HTTP ─▶ túnel SOCKS5 ─▶ Tor ─▶ tu .onion
```

Las pantallas nunca saben si los datos vienen del mock o del servidor: solo
hablan con las interfaces de `core/data/repositories.dart`.

- **Estado:** Riverpod (`flutter_riverpod`), sin generación de código.
- **Navegación:** `go_router`.
- **Red:** Connect RPC (`connectrpc`) sobre HTTP/1.1 dentro del servicio onion.
- **Tor:** cliente Arti embebido (paquete `tor`) o un proxy SOCKS5 externo.

## Carpetas de la raíz

| Carpeta / archivo | Qué es |
|---|---|
| `lib/` | Todo el código Dart de la app (detalle abajo). |
| `test/` | Pruebas automáticas. |
| `proto/v1/` | El contrato de la API (`.proto`). Es la fuente de verdad en la app. |
| `assets/images/` | Recursos. Hoy solo `logo.png`, la flor de allium. |
| `android/`, `ios/` | Proyectos nativos. Aquí van permisos, nombre de la app e íconos. |
| `linux/`, `macos/`, `windows/`, `web/` | Plataformas generadas por `flutter create`. No las usamos. |
| `build/` | Salida de compilación. Se puede borrar; está en `.gitignore`. |
| `pubspec.yaml` | Dependencias, assets y configuración del ícono. |
| `pubspec.lock` | Versiones exactas resueltas. |
| `analysis_options.yaml` | Reglas del analizador (lints). |
| `README.md` | Resumen, modelo de acceso y comandos. |
| `ARCHITECTURE.md` | Este archivo. |

## `lib/`

### `main.dart`
Punto de entrada. Envuelve todo en un `ProviderScope` (Riverpod) y arranca
`UmbelaApp`.

### `app/` — la cáscara de la aplicación
- `app.dart`: el `MaterialApp.router`. Aplica el tema y envuelve la app en
  `SessionLock`.
- `router.dart`: todas las rutas y la regla de acceso. Si no hay token de
  sesión, cualquier ruta redirige a `/login` (salvo `/scan`). Si lo hay, `/login`
  redirige a `/photos`.
- `theme/app_colors.dart`: la paleta exacta del PDF de diseño.
- `theme/app_theme.dart`: `ThemeData` y la escala de radios (14, 16, 18, 20, 22,
  28, 32 y píldora).
- `theme/app_typography.dart`: estilos de texto.
- `theme/app_icons.dart`: iconos Lucide en peso fino (300), cercano al trazo 1.5 del diseño.

### `core/` — lo compartido
Nada aquí depende de una pantalla concreta.

**`core/data/`: modelos y acceso a datos**
- `models.dart`: clases de dominio (`Photo`, `Person`, `Album`, `Place`,
  `PhotoDetails`, `PersonDetails`...). Son independientes de protobuf.
- `repositories.dart`: las **interfaces** (`PhotoRepository`, `PeopleRepository`,
  `AlbumRepository`, `PlaceRepository`, `AuthRepository`).
- `mock_repositories.dart`: implementación con datos de ejemplo, la que se usa por defecto.
- `connect_repositories.dart`: implementación real. Llama al servidor y
  convierte los mensajes protobuf a los modelos de dominio. Aquí también está la
  verificación de identidad del servidor antes de enviar la KEK.

**`core/network/`: conexión**
- `tor_proxy_service.dart`: interfaz `TorProxyService` con dos
  implementaciones: `ArtiTorProxyService` (Tor embebido) y
  `ExternalSocksProxyService` (un SOCKS5 que ya corre, para el emulador).
- `socks5.dart`: apretón de manos SOCKS5 (RFC 1928). Manda el nombre `.onion`
  como dominio, para que lo resuelva Tor y no el teléfono.
- `tunnel_socket.dart`: adapta el túnel SOCKS5 a un `Socket` de `dart:io`, para
  que el `HttpClient` normal pueda usarlo.
- `connect_client.dart`: `ConnectClientManager`. Construye el transporte
  Connect hacia el servidor vinculado y entrega los clientes generados.
- `session_interceptor.dart`: añade `Authorization: Bearer <token>` a cada
  llamada y avisa si el servidor responde `unauthenticated`.

**`core/security/`: llaves y vinculación**
- `pairing.dart`: `PairingData`, lo que trae el QR (`onion`, puerto, `salt`,
  clave pública del servidor) y su validación.
- `kek_deriver.dart`: calcula la KEK con Argon2id (mismos parámetros que el
  servidor Go), en un isolate para no congelar la interfaz.
- `server_identity.dart`: verifica la firma Ed25519 con la que el servidor
  demuestra ser el del QR.
- `security_controller.dart`: estado de seguridad: servidor vinculado, switch
  de biometría y si hay KEK guardada. Sabe guardarla, moverla entre
  almacenamientos y olvidarla.

**`core/storage/`**
- `secure_storage.dart`: `SecureStore` guarda el servidor vinculado y los
  switches en Keychain/Keystore. `KekVault` guarda la KEK, con biometría de
  hardware si el switch está encendido.

**`core/widgets/`: componentes que usan varias pantallas**
- `common.dart`: tarjeta, botón píldora, encabezado con buscador y avatar,
  punto verde de Tor, botón de regreso.
- `photo_grid.dart`: agrupación por fecha ("Hoy", "Ayer"...) y la cuadrícula tipo
  mampostería de 3 columnas.
- `map_widgets.dart`: el mapa minimalista y los pines.
- `security_sheet.dart`: la hoja del avatar (switch de biometría y "Cerrar sesión").

**Archivos sueltos de `core/`**
- `providers.dart`: **el centro de todo.** Define los providers de Riverpod
  (repositorios, Tor, cliente Connect, token de sesión, listas) y los flags de
  compilación `USE_MOCK` y `TOR_EXTERNAL`.
- `session_lock.dart`: si la biometría está activa, borra el token y cierra la
  conexión cuando la app pasa a segundo plano.
- `search.dart`: lógica del buscador (personas, álbumes, lugares y fechas).
- `utils/image_helpers.dart`: placeholder de rayas diagonales y círculos de avatar.

### `features/` — una carpeta por pantalla
Cada una tiene `presentation/` (las pantallas) y, si hace falta, `controllers/`
(lógica).

| Carpeta | Contiene |
|---|---|
| `auth/` | `login_screen.dart` (tres pasos: QR, contraseña, solo biometría), `qr_scan_screen.dart` y `controllers/login_controller.dart`. |
| `navigation/` | `main_navigation_wrapper.dart`: la barra inferior flotante de vidrio que contiene las cuatro pestañas. |
| `timeline/` | Pestaña **Fotos**. |
| `people/` | Pestaña **Personas** y el **detalle de persona**. |
| `albums/` | Pestaña **Álbumes** y la **vista de un álbum**. |
| `places/` | Pestaña **Lugares**. |
| `search/` | Pantalla de búsqueda. |
| `viewer/` | **Visor de foto**: foto completa y panel de detalles que se arrastra hacia arriba. |

### `gen/v1/` — código generado
Sale de `proto/v1/*.proto`. **No se edita a mano.** Los `*.pb*.dart` son los
mensajes, y `*.connect.client.dart` / `*.connect.spec.dart` los clientes Connect.
Se regenera con:

```
protoc -I proto --dart_out=lib/gen --connect-dart_out=lib/gen proto/v1/*.proto
```

## `proto/v1/` — el contrato con el servidor
- `auth.proto`: `AuthService` con `Identify` (el servidor demuestra su
  identidad) y `Unlock` (entrega la KEK una vez y devuelve el token de sesión).
- `photo.proto`: `PhotoService` con timeline, miniaturas y fotos completas en
  streaming, personas, álbumes y lugares.

El servidor Go todavía no implementa este contrato; hay que llevar estos
archivos a `umbela-server` y mantenerlos sincronizados.

## `test/`
| Archivo | Qué prueba |
|---|---|
| `app_flow_test.dart` | Flujos completos de la interfaz: vinculación, login, visor, búsqueda, álbum, bloqueo por biometría y cierre de sesión. |
| `security_test.dart` | La KEK contra un vector de referencia generado con el código Go, el parseo del QR y la verificación de identidad. |
| `connect_over_socks_test.dart` | Conexión Connect completa a través de un proxy SOCKS5 falso: que `Unlock` vaya sin token, que después vaya el `Bearer` y que un servidor impostor nunca reciba la KEK. |
| `socks5_test.dart` | El apretón de manos SOCKS5. |

## Cómo seguir el flujo de punta a punta

1. `main.dart` arranca la app y `router.dart` manda a `/login`.
2. `login_screen.dart` lee `securityProvider` para decidir el paso: sin servidor
   (QR), con servidor (contraseña) o con KEK guardada (solo biometría).
3. `login_controller.dart` deriva la KEK (`kek_deriver.dart`), levanta Tor
   (`tor_proxy_service.dart`) y llama a `authRepositoryProvider`.
4. `connect_repositories.dart` pide `Identify`, verifica la firma
   (`server_identity.dart`) y solo entonces manda `Unlock` con la KEK.
5. El servidor devuelve el token; `sessionTokenProvider` lo guarda **solo en
   RAM** y el router deja pasar a `/photos`.
6. Cada pantalla pide sus datos por un provider, que usa un repositorio, que usa
   `ConnectClientManager`, y el interceptor pone el `Bearer`.

## Dónde tocar según lo que quieras cambiar

| Quiero... | Voy a... |
|---|---|
| Cambiar colores o radios | `app/theme/` |
| Agregar una pantalla | Carpeta nueva en `features/`, ruta en `app/router.dart` |
| Agregar un dato nuevo del servidor | `proto/v1/*.proto`, regenerar `gen/`, modelo en `core/data/models.dart`, ambos repositorios (mock y Connect) |
| Cambiar cómo se desbloquea o se guarda la KEK | `core/security/`, `core/storage/` y `features/auth/` |
| Cambiar permisos, nombre o ícono | `android/` e `ios/` (el ícono se regenera con `dart run flutter_launcher_icons`) |
