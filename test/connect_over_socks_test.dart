import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:umbela_app/core/data/connect_repositories.dart';
import 'package:umbela_app/core/network/connect_client.dart';
import 'package:umbela_app/core/network/tor_proxy_service.dart';
import 'package:umbela_app/core/security/pairing.dart';
import 'package:umbela_app/core/security/server_identity.dart';
import 'package:umbela_app/gen/v1/auth.pb.dart' as auth;
import 'package:umbela_app/gen/v1/photo.pb.dart' as pb;

/// Minimal SOCKS5 proxy: records the requested domain and bridges to [target].
class FakeSocksProxy {
  FakeSocksProxy(this._server, this.target);
  final ServerSocket _server;
  final int target;
  final requestedHosts = <String>[];

  static Future<FakeSocksProxy> start(int target) async {
    final s = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    final p = FakeSocksProxy(s, target);
    s.listen(p._handle);
    return p;
  }

  int get port => _server.port;

  void _handle(Socket client) async {
    final buf = BytesBuilder();
    final events = StreamController<List<int>>();
    final sub = client.listen(events.add, onDone: events.close);
    final it = StreamIterator(events.stream);

    Future<List<int>> take(int n) async {
      while (buf.length < n) {
        if (!await it.moveNext()) return buf.takeBytes();
        buf.add(it.current);
      }
      final all = buf.takeBytes();
      buf.add(all.sublist(n));
      return all.sublist(0, n);
    }

    await take(3);
    client.add([5, 0]);
    final head = await take(5);
    final host = utf8.decode(await take(head[4]));
    await take(2);
    requestedHosts.add(host);
    final upstream = await Socket.connect('127.0.0.1', target);
    client.add([5, 0, 0, 1, 0, 0, 0, 0, 0, 0]);
    final rest = buf.takeBytes();
    if (rest.isNotEmpty) upstream.add(rest);
    sub.onData(upstream.add);
    sub.onDone(upstream.close);
    upstream.listen(client.add, onDone: client.close);
  }

  Future<void> close() => _server.close();
}

void main() {
  late HttpServer origin;
  late FakeSocksProxy proxy;
  late SimpleKeyPair serverKey;
  late PairingData pairing;
  final seenAuth = <String, String?>{};
  var unlockCalls = 0;
  late Future<SimpleKeyPair> identityKey;

  setUp(() async {
    seenAuth.clear();
    unlockCalls = 0;
    final ed = Ed25519();
    serverKey = await ed.newKeyPair();
    identityKey = Future.value(serverKey);

    origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((req) async {
      final body = await req.fold<List<int>>([], (a, b) => a..addAll(b));
      final path = req.uri.path;
      seenAuth[path] = req.headers.value('authorization');
      req.response.headers.contentType = ContentType('application', 'proto');
      switch (path) {
        case '/umbela.v1.AuthService/Identify':
          final nonce = auth.IdentifyRequest.fromBuffer(body).nonce;
          final sig = await ed.sign([
            ...utf8.encode(identifyContext),
            ...nonce,
          ], keyPair: await identityKey);
          req.response.add(
            auth.IdentifyResponse(signature: sig.bytes).writeToBuffer(),
          );
        case '/umbela.v1.AuthService/Unlock':
          unlockCalls++;
          expect(auth.UnlockRequest.fromBuffer(body).kek, List.filled(32, 9));
          req.response.add(
            auth.UnlockResponse(sessionToken: 'tok-1').writeToBuffer(),
          );
        case '/umbela.v1.PhotoService/ListAlbums':
          if (req.headers.value('authorization') != 'Bearer tok-1') {
            req.response
              ..statusCode = 401
              ..headers.contentType = ContentType.json
              ..write(
                jsonEncode({'code': 'unauthenticated', 'message': 'locked'}),
              );
          } else {
            req.response.add(
              pb.ListAlbumsResponse(
                albums: [
                  pb.AlbumSummary(
                    id: 'a1',
                    name: 'Familia',
                    photoCount: 3,
                    encrypted: true,
                  ),
                ],
              ).writeToBuffer(),
            );
          }
        default:
          req.response.statusCode = 404;
      }
      await req.response.close();
    });

    proxy = await FakeSocksProxy.start(origin.port);
    pairing = PairingData(
      onion: 'abcdefghijklmnop.onion',
      port: 80,
      salt: Uint8List(16),
      serverKey: Uint8List.fromList((await serverKey.extractPublicKey()).bytes),
    );
  });

  tearDown(() async {
    await origin.close(force: true);
    await proxy.close();
  });

  ConnectClientManager manager(
    String? Function() token,
    void Function() onUnauth,
  ) => ConnectClientManager(
    tor: ExternalSocksProxyService(port: proxy.port),
    sessionToken: token,
    onUnauthenticated: onUnauth,
  );

  test(
    'unlock goes through SOCKS5 with the .onion name, then Bearer auth works',
    () async {
      String? token;
      var unauth = 0;
      final client = manager(() => token, () => unauth++);
      final repo = ConnectAuthRepository(client);
      final kek = Uint8List.fromList(List.filled(32, 9));

      final res = await repo.unlock(server: pairing, kek: kek);
      expect(res.sessionToken, 'tok-1');
      expect(
        proxy.requestedHosts.every((h) => h == 'abcdefghijklmnop.onion'),
        isTrue,
      );
      // The KEK request carries no token: that is the whole point of the token.
      expect(seenAuth['/umbela.v1.AuthService/Unlock'], isNull);

      token = res.sessionToken;
      final albums = await client.photos.listAlbums(pb.ListAlbumsRequest());
      expect(albums.albums.single.name, 'Familia');
      expect(seenAuth['/umbela.v1.PhotoService/ListAlbums'], 'Bearer tok-1');

      // Server drops the session: the interceptor reports it.
      token = 'stale';
      await expectLater(
        client.photos.listAlbums(pb.ListAlbumsRequest()),
        throwsA(anything),
      );
      expect(unauth, 1);
      client.close();
    },
  );

  test('an impostor server never receives the KEK', () async {
    identityKey = Ed25519().newKeyPair(); // signs with a key not in the QR
    final client = manager(() => null, () {});
    final repo = ConnectAuthRepository(client);

    await expectLater(
      repo.unlock(server: pairing, kek: Uint8List(32)),
      throwsA(isA<ServerIdentityException>()),
    );
    expect(unlockCalls, 0);
    client.close();
  });
}
