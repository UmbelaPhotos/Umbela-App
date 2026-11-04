import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static const title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.ink,
    letterSpacing: -0.3,
  );
  static const section = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.stem,
  );
  static const body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.ink,
  );
  static const bodyBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );
  static const caption = TextStyle(
    fontSize: 11.5,
    fontWeight: FontWeight.w500,
    color: AppColors.stem,
  );
  static const label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );
}
