import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Diagonal lavender stripes with a centered icon, shown wherever a photo
/// has not loaded yet.
class StripedPlaceholder extends StatelessWidget {
  const StripedPlaceholder({
    super.key,
    required this.icon,
    this.radius = 14,
    this.iconSize = 24,
    this.bordered = true,
  });

  final IconData icon;
  final double radius;
  final double iconSize;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: bordered ? Border.all(color: AppColors.cardBorder) : null,
        ),
        child: CustomPaint(
          painter: _StripePainter(),
          child: Center(
            child: Icon(icon, size: iconSize, color: AppColors.floral),
          ),
        ),
      ),
    );
  }
}

class _StripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.inputBg);
    final paint = Paint()
      ..color = const Color(0xFFE2E6F5)
      ..strokeWidth = 11;
    const gap = 22.0;
    for (double x = -size.height; x < size.width + size.height; x += gap) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Circular face/cover placeholder with a lavender ring.
class AvatarCircle extends StatelessWidget {
  const AvatarCircle({
    super.key,
    required this.size,
    this.ring = 2.5,
    this.seed = 0,
  });

  final double size;
  final double ring;
  final int seed;

  static const _gradients = [
    [Color(0xFFB27ED8), Color(0xFF7E41B2)],
    [Color(0xFF7E41B2), Color(0xFF48186E)],
    [Color(0xFFD4BBE8), Color(0xFFA877CF)],
    [Color(0xFF5A2482), Color(0xFF2A0F45)],
  ];

  @override
  Widget build(BuildContext context) {
    final g = _gradients[seed % _gradients.length];
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.lavender, width: ring),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: g,
        ),
      ),
    );
  }
}
