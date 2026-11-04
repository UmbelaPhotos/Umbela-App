import 'dart:async';

import 'package:tor/tor.dart';

enum TorStatus { disconnected, connecting, connected }

/// Owns the Tor connection and exposes the local SOCKS5 endpoint.
abstract class TorProxyService {
  TorStatus get status;
  Stream<TorStatus> get statusStream;
  String get socksHost;
  int get socksPort;

  Future<void> start();
  Future<void> stop();
}

class _StatusHolder {
  TorStatus _status = TorStatus.disconnected;
  final _controller = StreamController<TorStatus>.broadcast();

  TorStatus get value => _status;
  Stream<TorStatus> get stream => _controller.stream;

  void set(TorStatus s) {
    if (s == _status) return;
    _status = s;
    _controller.add(s);
  }
}

/// Embedded Tor client (Arti) from the Foundation-Devices `tor` plugin.
class ArtiTorProxyService implements TorProxyService {
  final _holder = _StatusHolder();

  @override
  TorStatus get status => _holder.value;
  @override
  Stream<TorStatus> get statusStream => _holder.stream;
  @override
  String get socksHost => '127.0.0.1';
  @override
  int get socksPort => Tor.instance.port;

  @override
  Future<void> start() async {
    _holder.set(TorStatus.connecting);
    try {
      await Tor.init();
      await Tor.instance.start();
      _holder.set(TorStatus.connected);
    } catch (_) {
      _holder.set(TorStatus.disconnected);
      rethrow;
    }
  }

  @override
  Future<void> stop() async {
    await Tor.instance.stop();
    _holder.set(TorStatus.disconnected);
  }
}

/// Uses an already-running SOCKS5 proxy (Orbot, system `tor`, ...). Meant for
/// development on emulators.
class ExternalSocksProxyService implements TorProxyService {
  ExternalSocksProxyService({this.host = '127.0.0.1', this.port = 9050});

  final String host;
  final int port;
  final _holder = _StatusHolder();

  @override
  TorStatus get status => _holder.value;
  @override
  Stream<TorStatus> get statusStream => _holder.stream;
  @override
  String get socksHost => host;
  @override
  int get socksPort => port;

  @override
  Future<void> start() async {
    _holder.set(TorStatus.connecting);
    _holder.set(TorStatus.connected);
  }

  @override
  Future<void> stop() async => _holder.set(TorStatus.disconnected);
}
