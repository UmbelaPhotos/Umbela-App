import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppRadius {
  AppRadius._();

  static const double r14 = 14;
  static const double r16 = 16;
  static const double r18 = 18;
  static const double r20 = 20;
  static const double r22 = 22;
  static const double r28 = 28;
  static const double r32 = 32;
  static const double pill = 100;
}

class AppTheme {
  AppTheme._();

  static const iconStroke = 1.5;

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.bulb,
      primary: AppColors.bulb,
      surface: Colors.white,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      splashFactory: InkRipple.splashFactory,
      textTheme: Typography.blackMountainView.apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBg,
        hintStyle: const TextStyle(color: AppColors.stem, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: _border(Colors.transparent),
        enabledBorder: _border(Colors.transparent),
        focusedBorder: _border(AppColors.floral),
      ),
    );
  }

  static OutlineInputBorder _border(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.r18),
    borderSide: BorderSide(color: c, width: 1.5),
  );
}
