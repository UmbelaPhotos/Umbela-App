import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';
import 'security/security_controller.dart';

/// With biometrics ON, wipes the session token and closes the connection when
/// the app leaves the foreground; the router then shows the unlock screen.
class SessionLock extends ConsumerStatefulWidget {
  const SessionLock({
    super.key,
    required this.child,
    required this.onLocked,
    this.timeout = Duration.zero,
  });

  final Widget child;
  final VoidCallback onLocked;

  /// How long the app may stay in background before locking.
  final Duration timeout;

  @override
  ConsumerState<SessionLock> createState() => _SessionLockState();
}

class _SessionLockState extends ConsumerState<SessionLock>
    with WidgetsBindingObserver {
  DateTime? _backgroundedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        _backgroundedAt ??= DateTime.now();
        if (widget.timeout == Duration.zero) _lock();
      case AppLifecycleState.resumed:
        final since = _backgroundedAt;
        _backgroundedAt = null;
        if (since != null &&
            DateTime.now().difference(since) >= widget.timeout) {
          _lock();
        }
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  void _lock() {
    if (ref.read(sessionTokenProvider) == null &&
        !ref.read(pendingUnlockProvider)) {
      return;
    }
    // Only users who chose biometrics get a lock; without it the app stays
    // open and the server decides when a new Unlock is needed.
    if (ref.read(securityProvider).value?.biometric != true) return;
    ref.read(sessionTokenProvider.notifier).clear();
    ref.read(pendingUnlockProvider.notifier).set(false);
    if (!useMock) ref.read(connectClientProvider).close();
    widget.onLocked();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
