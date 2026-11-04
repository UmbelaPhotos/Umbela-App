import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:async/async.dart';

class Socks5Exception implements Exception {
  Socks5Exception(this.message);
  final String message;
  @override
  String toString() => 'Socks5Exception: $message';
}

/// An open SOCKS5 tunnel: [incoming] carries bytes after the handshake.
class Socks5Tunnel {
  Socks5Tunnel(this.socket, this.incoming);
  final Socket socket;
  final Stream<List<int>> incoming;
}

/// RFC 1928 CONNECT with a domain-name address (ATYP 3), so the `.onion` name
/// is resolved by Tor and never by the local resolver.
Future<Socks5Tunnel> socks5Connect({
  required String proxyHost,
  required int proxyPort,
  required String targetHost,
  required int targetPort,
  Duration timeout = const Duration(seconds: 60),
}) async {
  final host = utf8.encode(targetHost);
  if (host.length > 255) throw Socks5Exception('hostname too long');

  final socket = await Socket.connect(proxyHost, proxyPort, timeout: timeout);
  socket.setOption(SocketOption.tcpNoDelay, true);
  final reader = _Reader(StreamQueue<List<int>>(socket));

  try {
    await _handshake(socket, reader.read, host, targetPort).timeout(timeout);
  } catch (_) {
    socket.destroy();
    rethrow;
  }
  return Socks5Tunnel(socket, reader.rest());
}

/// Reads exact byte counts from a stream, keeping any surplus so it can be
/// handed back untouched once the handshake is done.
class _Reader {
  _Reader(this._queue);

  final StreamQueue<List<int>> _queue;
  List<int> _pending = const [];

  Future<Uint8List> read(int n) async {
    final out = BytesBuilder();
    while (out.length < n) {
      if (_pending.isEmpty) {
        if (!await _queue.hasNext) throw Socks5Exception('proxy closed early');
        _pending = await _queue.next;
        continue;
      }
      final take = _pending.length < n - out.length
          ? _pending.length
          : n - out.length;
      out.add(_pending.sublist(0, take));
      _pending = _pending.sublist(take);
    }
    return out.takeBytes();
  }

  Stream<List<int>> rest() async* {
    if (_pending.isNotEmpty) yield _pending;
    yield* _queue.rest;
  }
}

Future<void> _handshake(
  Socket socket,
  Future<Uint8List> Function(int) read,
  List<int> host,
  int port,
) async {
  socket.add([0x05, 0x01, 0x00]); // v5, 1 method: no auth
  final choice = await read(2);
  if (choice[0] != 0x05 || choice[1] != 0x00) {
    throw Socks5Exception('proxy rejected "no authentication"');
  }

  socket.add([
    0x05, 0x01, 0x00, 0x03, host.length, //
    ...host,
    (port >> 8) & 0xff, port & 0xff,
  ]);
  final head = await read(4);
  if (head[0] != 0x05) throw Socks5Exception('bad reply version');
  if (head[1] != 0x00) throw Socks5Exception(_replyText(head[1]));
  switch (head[3]) {
    case 0x01:
      await read(4 + 2);
    case 0x04:
      await read(16 + 2);
    case 0x03:
      final len = (await read(1))[0];
      await read(len + 2);
    default:
      throw Socks5Exception('unknown address type ${head[3]}');
  }
}

String _replyText(int code) => switch (code) {
  0x01 => 'general SOCKS server failure',
  0x02 => 'connection not allowed',
  0x03 => 'network unreachable',
  0x04 => 'host unreachable',
  0x05 => 'connection refused',
  0x06 => 'TTL expired',
  0x07 => 'command not supported',
  0x08 => 'address type not supported',
  _ => 'unknown SOCKS error $code',
};
