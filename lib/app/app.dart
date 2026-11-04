import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/session_lock.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class UmbelaApp extends ConsumerWidget {
  const UmbelaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Umbela',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: router,
      // Locking clears the token; the router redirect then shows /login.
      builder: (context, child) =>
          SessionLock(onLocked: () {}, child: child ?? const SizedBox()),
    );
  }
}
