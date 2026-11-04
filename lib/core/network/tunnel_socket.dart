import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'socks5.dart';

/// A [Socket] whose reads come from the post-handshake stream of a SOCKS5
/// tunnel and whose writes go straight to the underlying socket. It lets
/// `dart:io`'s HttpClient run over Tor.
class TunnelSocket extends StreamView<Uint8List> implements Socket {
  TunnelSocket(Socks5Tunnel tunnel)
    : _socket = tunnel.socket,
      super(
        tunnel.incoming.map((c) => c is Uint8List ? c : Uint8List.fromList(c)),
      );

  final Socket _socket;

  @override
  InternetAddress get address => _socket.address;
  @override
  InternetAddress get remoteAddress => _socket.remoteAddress;
  @override
  int get port => _socket.port;
  @override
  int get remotePort => _socket.remotePort;

  @override
  Encoding get encoding => _socket.encoding;
  @override
  set encoding(Encoding value) => _socket.encoding = value;

  @override
  void add(List<int> data) => _socket.add(data);
  @override
  void addError(Object error, [StackTrace? stackTrace]) =>
      _socket.addError(error, stackTrace);
  @override
  Future addStream(Stream<List<int>> stream) => _socket.addStream(stream);
  @override
  Future close() => _socket.close();
  @override
  Future get done => _socket.done;
  @override
  void destroy() => _socket.destroy();
  @override
  Future flush() => _socket.flush();
  @override
  bool setOption(SocketOption option, bool enabled) =>
      _socket.setOption(option, enabled);
  @override
  Uint8List getRawOption(RawSocketOption option) =>
      _socket.getRawOption(option);
  @override
  void setRawOption(RawSocketOption option) => _socket.setRawOption(option);
  @override
  void write(Object? object) => _socket.write(object);
  @override
  void writeAll(Iterable objects, [String separator = '']) =>
      _socket.writeAll(objects, separator);
  @override
  void writeCharCode(int charCode) => _socket.writeCharCode(charCode);
  @override
  void writeln([Object? object = '']) => _socket.writeln(object);
}
