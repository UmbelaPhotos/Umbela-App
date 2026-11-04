import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_icons.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../network/tor_proxy_service.dart';
import '../providers.dart';
import 'security_sheet.dart';

/// White card with a very soft lilac border and a purple-tinted shadow.
class UmbelaCard extends StatelessWidget {
  const UmbelaCard({
    super.key,
    required this.child,
    this.radius = AppRadius.r20,
    this.padding,
    this.onTap,
  });

  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(radius);
    return Material(
      color: Colors.white,
      borderRadius: shape,
      child: InkWell(
        borderRadius: shape,
        onTap: onTap,
        child: Ink(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: shape,
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 14,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.ghost = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool ghost;

  @override
  Widget build(BuildContext context) {
    final fg = ghost ? AppColors.deep : Colors.white;
    return Opacity(
      opacity: onPressed == null ? 0.5 : 1,
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: ghost ? Colors.transparent : AppColors.deep,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: ghost ? Border.all(color: AppColors.floral) : null,
            boxShadow: ghost
                ? null
                : const [
                    BoxShadow(
                      color: Color(0x4D48186E),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              onTap: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18, color: fg),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: fg,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Only green on screen: a discreet "connected through Tor" dot.
class TorStatusDot extends ConsumerWidget {
  const TorStatusDot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(torStatusProvider).value ?? TorStatus.disconnected;
    final color = switch (status) {
      TorStatus.connected => AppColors.torOnline,
      TorStatus.connecting => AppColors.floral,
      TorStatus.disconnected => AppColors.stem.withValues(alpha: 0.4),
    };
    return Container(
      key: const ValueKey('tor-dot'),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
    );
  }
}

/// Header logo: while Tor is still connecting it breathes and a ring spins
/// around it, so the user knows the network is loading.
class _HeaderLogo extends ConsumerStatefulWidget {
  const _HeaderLogo();

  @override
  ConsumerState<_HeaderLogo> createState() => _HeaderLogoState();
}

class _HeaderLogoState extends ConsumerState<_HeaderLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  void _sync(bool connecting) {
    if (connecting && !_ctrl.isAnimating) {
      _ctrl.repeat();
    } else if (!connecting && _ctrl.isAnimating) {
      _ctrl.animateTo(1).whenComplete(() {
        if (mounted) _ctrl.value = 0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final status = ref.read(torStatusProvider).value;
    _sync(status != TorStatus.connected);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(torStatusProvider, (_, next) {
      _sync(next.value != TorStatus.connected);
    });
    final status = ref.watch(torStatusProvider).value;
    final connecting = status != TorStatus.connected;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final t = _ctrl.value;
        final pulse = connecting ? (math.sin(t * 2 * math.pi) + 1) / 2 : 0.0;
        return SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              if (connecting)
                Transform.rotate(
                  angle: t * 2 * math.pi,
                  child: SizedBox(
                    width: 46,
                    height: 46,
                    child: CustomPaint(painter: _HeaderRingPainter()),
                  ),
                ),
              Transform.scale(
                scale: 1 + 0.06 * pulse,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.lavender, width: 2),
                    boxShadow: connecting
                        ? [
                            BoxShadow(
                              color: AppColors.floral.withValues(
                                alpha: 0.25 + 0.35 * pulse,
                              ),
                              blurRadius: 12,
                              spreadRadius: 1 + 2 * pulse,
                            ),
                          ]
                        : null,
                  ),
                  child: child,
                ),
              ),
            ],
          ),
        );
      },
      child: ClipOval(
        child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
      ),
    );
  }
}

class _HeaderRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [AppColors.floral.withValues(alpha: 0), AppColors.floral],
      ).createShader(rect);
    canvas.drawArc(rect.deflate(1), 0, math.pi * 1.5, false, paint);
  }

  @override
  bool shouldRepaint(_HeaderRingPainter old) => false;
}

/// Logo + pill search + avatar with Tor dot.
class AppHeader extends StatelessWidget {
  const AppHeader({super.key, this.translucent = false});

  /// Floats over the map on the Places tab.
  final bool translucent;

  @override
  Widget build(BuildContext context) {
    final bg = translucent
        ? Colors.white.withValues(alpha: 0.78)
        : AppColors.inputBg;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        children: [
          const _HeaderLogo(),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              key: const ValueKey('search-bar'),
              behavior: HitTestBehavior.opaque,
              onTap: () => context.push('/search'),
              child: Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: const Row(
                  children: [
                    Icon(AppIcons.search, size: 18, color: AppColors.stem),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Buscar personas, lugares o fechas...',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: AppColors.stem),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            key: const ValueKey('settings'),
            behavior: HitTestBehavior.opaque,
            onTap: () => showSecuritySheet(context),
            child: const Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: 38,
                  height: 38,
                  child: Icon(
                    AppIcons.moreVertical,
                    size: 22,
                    color: AppColors.ink,
                  ),
                ),
                Positioned(right: 2, bottom: 2, child: TorStatusDot()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Round back button on lavender-blue.
class RoundBackButton extends StatelessWidget {
  const RoundBackButton({super.key});

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.inputBg,
    shape: const CircleBorder(),
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: () => context.pop(),
      child: const SizedBox(
        width: 38,
        height: 38,
        child: Icon(AppIcons.arrowLeft, size: 20, color: AppColors.deep),
      ),
    ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.icon});
  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      if (icon != null) ...[
        Icon(icon, size: 15, color: AppColors.stem),
        const SizedBox(width: 6),
      ],
      Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.stem,
        ),
      ),
    ],
  );
}

/// Pull-down-to-reload for any scrollable that always accepts the drag (give
/// it `AlwaysScrollableScrollPhysics`, or use [ErrorView]).
class PullRefresh extends StatelessWidget {
  const PullRefresh({super.key, required this.onRefresh, required this.child});

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    color: AppColors.deep,
    backgroundColor: Colors.white,
    onRefresh: onRefresh,
    child: child,
  );
}

/// Full-area error that can still be pulled down to retry.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, required this.onRetry});

  final Object error;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return PullRefresh(
      onRefresh: onRetry,
      child: LayoutBuilder(
        builder: (context, c) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: c.maxHeight,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'No se pudo cargar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Desliza hacia abajo para reintentar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: AppColors.stem),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$error',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.stem,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reloads a [FutureProvider] and waits for the result, swallowing the error
/// (the screen shows it).
Future<void> reloadProvider<T>(
  WidgetRef ref,
  FutureProvider<T> provider,
) async {
  ref.invalidate(provider);
  try {
    await ref.read(provider.future);
  } catch (_) {}
}
