// ignore_for_file: prefer_initializing_formals
import 'dart:async';
import 'dart:io' as io;

import 'package:connectrpc/io.dart';
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;

import '../../gen/v1/auth.connect.client.dart';
import '../../gen/v1/auth.pb.dart' show IdentifyRequest;
import '../../gen/v1/photo.connect.client.dart';
import '../security/pairing.dart';
import 'session_interceptor.dart';
import 'socks5.dart';
import 'tor_proxy_service.dart';
import 'tunnel_socket.dart';

/// Builds the Connect transport for the paired `.onion`. Plain HTTP is fine:
/// an onion service is already end-to-end encrypted and authenticated.
class ConnectClientManager {
  ConnectClientManager({
    required this.tor,
    required String? Function() sessionToken,
    required void Function() onUnauthenticated,
  }) : _sessionToken = sessionToken,
       _onUnauthenticated = onUnauthenticated;

  final TorProxyService tor;
  final String? Function() _sessionToken;
  final void Function() _onUnauthenticated;

  protocol.Transport? _transport;
  io.HttpClient? _http;
  PairingData? _server;

  /// Starts Tor if needed and points the transport at [server].
  Future<void> connect(PairingData server) async {
    if (_transport != null && _server == server) return;
    close();
    if (tor.status != TorStatus.connected) await tor.start();
    _server = server;
    final http = io.HttpClient()
      ..findProxy = ((_) => 'DIRECT')
      // Opening a connection to an onion costs a whole circuit; keep the
      // ones we have open for a good while.
      ..idleTimeout = const Duration(minutes: 5)
      ..connectionFactory = (uri, _, _) {
        final tunnel = socks5Connect(
          proxyHost: tor.socksHost,
          proxyPort: tor.socksPort,
          targetHost: uri.host,
          targetPort: uri.port,
        );
        return Future.value(
          io.ConnectionTask.fromSocket(
            tunnel.then<io.Socket>(TunnelSocket.new),
            () {},
          ),
        );
      };
    _http = http;
    _transport = protocol.Transport(
      baseUrl: server.baseUrl,
      codec: const ProtoCodec(),
      httpClient: createHttpClient(http),
      interceptors: [
        sessionInterceptor(
          token: _sessionToken,
          onUnauthenticated: _onUnauthenticated,
        ),
      ],
    );
    unawaited(_warmUp());
  }

  /// Opens a few connections ahead of time (each one a Tor circuit to the
  /// onion) so the first screen of thumbnails does not pay for building them.
  /// `Identify` needs no session and is cheap; the answer is discarded.
  Future<void> _warmUp({int connections = 3}) async {
    final transport = _transport;
    if (transport == null) return;
    await Future.wait([
      for (var i = 0; i < connections; i++)
        AuthServiceClient(transport)
            .identify(IdentifyRequest(nonce: List.filled(32, i)))
            .then<void>((_) {}, onError: (Object _) {}),
    ]);
  }

  protocol.Transport get _t {
    final t = _transport;
    if (t == null) throw StateError('Not connected to a server');
    return t;
  }

  AuthServiceClient get auth => AuthServiceClient(_t);
  PhotoServiceClient get photos => PhotoServiceClient(_t);

  void close() {
    _http?.close(force: true);
    _http = null;
    _transport = null;
    _server = null;
  }
}
