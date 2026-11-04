import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../providers.dart';
import '../security/security_controller.dart';
import 'common.dart';

Future<void> showSecuritySheet(BuildContext context) => showModalBottomSheet(
  context: context,
  // The root navigator, so the sheet covers the floating tab bar.
  useRootNavigator: true,
  backgroundColor: Colors.white,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.r32)),
  ),
  builder: (_) => const _SecuritySheet(),
);

class _SecuritySheet extends ConsumerWidget {
  const _SecuritySheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(securityProvider).value ?? const SecurityState();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seguridad',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Pedir biometría cada vez',
                    style: TextStyle(fontSize: 14, color: AppColors.ink),
                  ),
                ),
                Switch(
                  key: const ValueKey('sheet-biometric'),
                  value: s.biometric,
                  activeThumbColor: Colors.white,
                  activeTrackColor: AppColors.bulb,
                  onChanged: (v) =>
                      ref.read(securityProvider.notifier).setBiometric(v),
                ),
              ],
            ),
            Text(
              s.biometric
                  ? 'La app se bloquea al salir y se abre con tu huella o rostro.'
                  : 'La app se abre sin pedir nada y no se bloquea al salir.',
              style: const TextStyle(fontSize: 12, color: AppColors.stem),
            ),
            const SizedBox(height: 18),
            PillButton(
              label: 'Cerrar sesión',
              ghost: true,
              onPressed: () async {
                Navigator.of(context).pop();
                await ref.read(securityProvider.notifier).unlink();
                ref.read(sessionTokenProvider.notifier).clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}
