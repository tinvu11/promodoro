import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background
  static const bg = Color(0xFF0F172A);

  // Glass layers
  static const glassPrimary = Color(0x33FFFFFF); // white 20%
  static const glassSecondary = Color(0x1AFFFFFF); // white 10%
  static const glassBorder = Color(0x66FFFFFF); // white border

  // Accent glow
  static const accent = Color(0xFF7C7CFF); // blue-purple
  static const accentSoft = Color(0x667C7CFF);

  // Text
  static const textPrimary = Color(0xF2FFFFFF); // white 95%
  static const textSecondary = Color(0xB3FFFFFF); // white 70%

  static final glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color(0xFFFFFFFF).withAlpha(40),
      const Color(0xFFFFFFFF).withAlpha(30),
    ],
  );
}
