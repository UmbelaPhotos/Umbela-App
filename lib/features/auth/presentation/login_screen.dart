import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_icons.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/providers.dart';
import '../../../core/security/pairing.dart';
import '../../../core/security/security_controller.dart';
import '../../../core/widgets/common.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _pass = TextEditingController();
  bool? _biometric; // null until the user touches the switch

  @override
  void initState() {
    super.initState();
    _pass.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => _autoUnlock());
  }

  @override
  void dispose() {
    _pass.dispose();
    super.dispose();
  }

  /// Returning user: the KEK is already on the phone, so skip the password.
  Future<void> _autoUnlock() async {
    final s = await ref.read(securityProvider.future);
    if (!mounted || s.pairing == null || !s.kekStored) return;
    await ref.read(loginControllerProvider.notifier).unlockStored();
  }

  void _submit(bool biometric) => ref
      .read(loginControllerProvider.notifier)
      .login(_pass.text, biometric: biometric);

  Future<void> _pairFromQr() async {
    if (useMock) {
      // No camera in the demo: pair with a made-up server.
      await ref.read(securityProvider.notifier).pair(demoPairing());
    } else {
      await context.push('/scan');
    }
  }

  @override
  Widget build(BuildContext context) {
    final login = ref.watch(loginControllerProvider);
    final security = ref.watch(securityProvider).value ?? const SecurityState();
    final biometric = _biometric ?? security.biometric;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.5),
            radius: 1.1,
            colors: [AppColors.loginTop, AppColors.deep, AppColors.loginBottom],
            stops: [0, 0.55, 1],
          ),
        ),
        child: Column(
          children: [
            Expanded(child: _Brand(connecting: login.isLoading)),
            _Sheet(
              pass: _pass,
              hasPassword: _pass.text.isNotEmpty,
              pairing: security.pairing,
              canUnlockStored: security.kekStored,
              biometric: biometric,
              onBiometric: (v) => setState(() => _biometric = v),
              loading: login.isLoading,
              error: login.hasError ? login.error.toString() : null,
              onSubmit: () => _submit(biometric),
              onUnlockStored: () =>
                  ref.read(loginControllerProvider.notifier).unlockStored(),
              onQr: _pairFromQr,
            ),
          ],
        ),
      ),
    );
  }
}

PairingData demoPairing() => PairingData(
  onion: 'demo.onion',
  port: 80,
  salt: Uint8List.fromList(List.generate(16, (i) => i + 1)),
  serverKey: Uint8List(32),
);

class _Brand extends StatefulWidget {
  const _Brand({required this.connecting});

  /// Waiting for Tor: the logo breathes and a ring spins around it.
  final bool connecting;

  @override
  State<_Brand> createState() => _BrandState();
}

class _BrandState extends State<_Brand> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void initState() {
    super.initState();
    if (widget.connecting) _ctrl.repeat();
  }

  @override
  void didUpdateWidget(_Brand old) {
    super.didUpdateWidget(old);
    if (widget.connecting && !_ctrl.isAnimating) {
      _ctrl.repeat();
    } else if (!widget.connecting && _ctrl.isAnimating) {
      _ctrl.animateTo(1).whenComplete(() => _ctrl.value = 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _ctrl,
                builder: (context, child) {
                  final t = _ctrl.value;
                  final pulse = widget.connecting
                      ? (math.sin(t * 2 * math.pi) + 1) / 2
                      : 0.0;
                  return SizedBox(
                    width: 148,
                    height: 148,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (widget.connecting)
                          Transform.rotate(
                            angle: t * 2 * math.pi,
                            child: SizedBox(
                              width: 148,
                              height: 148,
                              child: CustomPaint(painter: _RingPainter()),
                            ),
                          ),
                        Transform.scale(
                          scale: 1 + 0.05 * pulse,
                          child: Container(
                            width: 124,
                            height: 124,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.floral.withValues(
                                    alpha: 0.55 + 0.35 * pulse,
                                  ),
                                  blurRadius: 60,
                                  spreadRadius: 6 + 8 * pulse,
                                ),
                              ],
                            ),
                            child: child,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Bienvenido a Umbela',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Tu fototeca soberana y privada',
                style: TextStyle(color: AppColors.lavender, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _Step { scan, password, stored }

/// Three steps: no server yet -> only the QR button; server paired -> password
/// (first login only); KEK on the phone -> just the biometric check.
class _Sheet extends StatelessWidget {
  const _Sheet({
    required this.pass,
    required this.hasPassword,
    required this.pairing,
    required this.canUnlockStored,
    required this.biometric,
    required this.onBiometric,
    required this.loading,
    required this.error,
    required this.onSubmit,
    required this.onUnlockStored,
    required this.onQr,
  });

  final TextEditingController pass;
  final bool hasPassword;
  final PairingData? pairing;
  final bool canUnlockStored;
  final bool biometric;
  final ValueChanged<bool> onBiometric;
  final bool loading;
  final String? error;
  final VoidCallback onSubmit;
  final VoidCallback onUnlockStored;
  final VoidCallback onQr;

  _Step get _step => pairing == null
      ? _Step.scan
      : canUnlockStored
      ? _Step.stored
      : _Step.password;

  @override
  Widget build(BuildContext context) {
    final step = _step;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        24,
        26,
        24,
        20 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.r32),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x335A2482),
            blurRadius: 30,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            switch (step) {
              _Step.scan => 'Vincula tu servidor',
              _Step.password => 'Crea tu acceso',
              _Step.stored => 'Desbloquear',
            },
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            switch (step) {
              _Step.scan =>
                'Escanea el QR que muestra "umbela pair" en tu servidor',
              _Step.password =>
                'Servidor: ${_short(pairing!.onion)}. Escribe tu contraseña una sola vez.',
              _Step.stored =>
                biometric
                    ? 'Confirma con tu huella o rostro para entrar'
                    : 'Servidor: ${_short(pairing!.onion)}',
            },
            key: const ValueKey('server-line'),
            style: const TextStyle(fontSize: 12.5, color: AppColors.stem),
          ),
          const SizedBox(height: 18),
          if (step == _Step.password) ...[
            TextField(
              key: const ValueKey('field-pass'),
              controller: pass,
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              onSubmitted: (_) => hasPassword ? onSubmit() : null,
              style: const TextStyle(fontSize: 14.5, color: AppColors.ink),
              decoration: const InputDecoration(
                hintText: 'Contraseña',
                prefixIcon: Icon(
                  AppIcons.lock,
                  size: 20,
                  color: AppColors.stem,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Pedir biometría cada vez',
                    style: TextStyle(fontSize: 13, color: AppColors.ink),
                  ),
                ),
                Switch(
                  key: const ValueKey('switch-biometric'),
                  value: biometric,
                  activeThumbColor: Colors.white,
                  activeTrackColor: AppColors.bulb,
                  onChanged: onBiometric,
                ),
              ],
            ),
          ],
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                error!,
                key: const ValueKey('login-error'),
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.destructive,
                ),
              ),
            ),
          switch (step) {
            _Step.scan => PillButton(
              label: 'Escanear QR',
              icon: AppIcons.qrCode,
              onPressed: loading ? null : onQr,
            ),
            _Step.password => PillButton(
              label: loading ? 'Conectando por Tor...' : 'Iniciar sesión',
              onPressed: loading || !hasPassword ? null : onSubmit,
            ),
            _Step.stored => PillButton(
              label: loading
                  ? 'Conectando por Tor...'
                  : biometric
                  ? 'Desbloquear con biometría'
                  : 'Entrar',
              onPressed: loading ? null : onUnlockStored,
            ),
          },
          if (step == _Step.password && !loading) ...[
            const SizedBox(height: 10),
            PillButton(
              label: 'Escanear otro QR',
              icon: AppIcons.qrCode,
              ghost: true,
              onPressed: onQr,
            ),
          ],
        ],
      ),
    );
  }

  static String _short(String onion) => onion.length <= 22
      ? onion
      : '${onion.substring(0, 8)}…${onion.substring(onion.length - 12)}';
}

/// Arc that spins around the logo while connecting.
class _RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [Colors.white.withValues(alpha: 0), Colors.white],
      ).createShader(rect);
    canvas.drawArc(rect.deflate(2), 0, math.pi * 1.5, false, paint);
  }

  @override
  bool shouldRepaint(_RingPainter old) => false;
}
