import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand colors pulled from the Astro logo.
  static const Color brandOrange = Color(0xFFFFA033);
  static const Color brandOrangeDark = Color(0xFFFF8A00);
  static const Color brandPink = Color(0xFFFF37A3);
  static const Color brandRed = Color(0xFF8B4743);

  // Cosmic night tones used for accents and dark sections.
  static const Color night = Color(0xFF2B1B3D);
  static const Color nightDeep = Color(0xFF1C0F2E);

  // Warm ivory canvas to echo the logo's off-white background.
  static const Color canvas = Color(0xFFFCFEFF);
  static const Color surface = Colors.white;

  static const Color textPrimary = Color(0xFF37393B);
  static const Color textSecondary = Color(0xFF8A8480);
  static const Color textHint = Color(0xFFBFB9B2);

  static const Color success = Color(0xFF2E9E5B);
  static const Color warning = Color(0xFFF2A33C);
  static const Color info = Color(0xFF3D7BF2);

  static const Color starGold = Color(0xFFF6C945);
  static const Color ink = Color(0xFF241236);

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandOrange, brandPink],
  );

  static const LinearGradient brandGradientSoft = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFD9A8), Color(0xFFF7B7D8)],
  );

  static const LinearGradient nightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandOrange, brandPink],
  );

  static const LinearGradient scoreGradient = LinearGradient(
    colors: [brandOrange, brandPink],
  );
}
