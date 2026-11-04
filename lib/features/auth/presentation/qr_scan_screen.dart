import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/security/pairing.dart';
import '../../../core/security/security_controller.dart';
import '../../../core/widgets/common.dart';

/// Scans the QR printed by `umbela pair` and stores the pairing data.
class QrScanScreen extends ConsumerStatefulWidget {
  const QrScanScreen({super.key});

  @override
  ConsumerState<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends ConsumerState<QrScanScreen> {
  String? _error;
  bool _busy = false;

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_busy) return;
    final raw = capture.barcodes.map((b) => b.rawValue).whereType<String>();
    if (raw.isEmpty) return;
    _busy = true;
    try {
      final data = PairingData.parse(raw.first);
      await ref.read(securityProvider.notifier).pair(data);
      if (mounted) context.pop();
    } on PairingFormatException catch (e) {
      setState(() => _error = e.message);
      await Future<void>.delayed(const Duration(seconds: 2));
      _busy = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.viewerBg,
      body: Stack(
        children: [
          MobileScanner(onDetect: _onDetect),
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topLeft,
                child: RoundBackButton(),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 48,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(AppRadius.r22),
              ),
              child: Text(
                _error ??
                    'Apunta al QR que muestra "umbela pair" en tu servidor',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: _error == null ? AppColors.ink : AppColors.destructive,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
