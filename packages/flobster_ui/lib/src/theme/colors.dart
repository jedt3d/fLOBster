import 'package:flutter/material.dart';

/// Premium visual palette for the fLOBster design system.
/// Features a dark mode default, vibrant gradients, and glassmorphic surface colors.
class FlobsterColors {
  FlobsterColors._();

  // Core HSL/Hex Backgrounds
  static const Color darkBackground = Color(0xFF0F111A); // Deep Indigo Gray
  static const Color surfaceGlass = Color(0xB31E2233); // Translucent Glass Slate (rgba(30, 34, 51, 0.7))
  static const Color surfaceSolid = Color(0xFF1E2233); // Solid Glass Slate for non-glass Fallbacks

  // Border Accent Color
  static const Color borderGlass = Color(0x33FFFFFF); // Subtle translucent border

  // Interactive Brand Gradients (Electric Cyan to Royal Blue)
  static const Color brandCyan = Color(0xFF00F2FE);
  static const Color brandBlue = Color(0xFF4FACFE);

  static const LinearGradient brandGradient = LinearGradient(
    colors: [brandCyan, brandBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Semantic Status Tones
  static const Color successMint = Color(0xFF00F5A0); // Mint Emerald
  static const Color warningRose = Color(0xFFFF4B6E); // Bright Rosewood

  // Text Contrast Shades
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A5C0);
}
