import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_icons.dart';

/// Minimal lavender-grid "map": no tiles, nothing outside the palette.
class GridMapPainter extends CustomPainter {
  const GridMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.inputBg);
    final line = Paint()
      ..color = AppColors.lavender.withValues(alpha: 0.45)
      ..strokeWidth = 1;
    const step = 28.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Teardrop pin with a white MapPin icon.
class MapPinMarker extends StatelessWidget {
  const MapPinMarker({super.key, this.size = 34, this.onTap});

  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final body = size * 0.82;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: size,
        height: size * 1.15,
        child: Center(
          child: Transform.rotate(
            angle: -math.pi / 4,
            child: Container(
              width: body,
              height: body,
              decoration: const BoxDecoration(
                color: AppColors.deep,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                  topRight: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                  bottomLeft: Radius.circular(6),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x5948186E),
                    blurRadius: 10,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              child: Transform.rotate(
                angle: math.pi / 4,
                child: Icon(
                  AppIcons.mapPin,
                  size: body * 0.5,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
