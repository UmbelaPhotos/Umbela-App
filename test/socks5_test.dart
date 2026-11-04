import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:umbela_app/core/network/socks5.dart';

void main() {
  test(
    'SOCKS5 CONNECT sends the .onion as a domain and keeps tunnel bytes',
    () async {
      final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      final seen = Completer<List<int>>();
      server.listen((s) {
        final buf = <int>[];
        var stage = 0;
        s.listen((data) {
          buf.addAll(data);
          if (stage == 0 && buf.length >= 3) {
            expect(buf.sublist(0, 3), [5, 1, 0]);
            buf.removeRange(0, 3);
            stage = 1;
            s.add([5, 0]);
          }
          if (stage == 1) {
            if (buf.length < 5) return;
            final need = 5 + buf[4] + 2;
            if (buf.length < need) return;
            seen.complete(List.of(buf.sublist(0, need)));
            stage = 2;
            // Success reply (IPv4) glued to the first tunnel bytes, to check
            // that surplus bytes are not lost.
            s.add([5, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0x68, 0x69]);
          }
        });
      });

      final tunnel = await socks5Connect(
        proxyHost: '127.0.0.1',
        proxyPort: server.port,
        targetHost: 'abcdef.onion',
        targetPort: 50051,
      );
      final req = await seen.future;
      expect(req.sublist(0, 4), [5, 1, 0, 3]);
      expect(req[4], 'abcdef.onion'.length);
      expect(utf8.decode(req.sublist(5, 5 + req[4])), 'abcdef.onion');
      expect(req.sublist(req.length - 2), [0xC3, 0x83]); // 50051

      final first = await tunnel.incoming.first;
      expect(first, [0x68, 0x69]);

      tunnel.socket.destroy();
      await server.close();
    },
  );

  test('SOCKS5 error replies surface as exceptions', () async {
    final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((s) {
      var n = 0;
      s.listen((_) {
        if (n++ == 0) {
          s.add([5, 0]);
        } else {
          s.add([5, 4, 0, 1, 0, 0, 0, 0, 0, 0]);
        }
      });
    });
    expect(
      socks5Connect(
        proxyHost: '127.0.0.1',
        proxyPort: server.port,
        targetHost: 'x.onion',
        targetPort: 1,
      ),
      throwsA(isA<Socks5Exception>()),
    );
  });
}
