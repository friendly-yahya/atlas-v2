//temporary 

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  // ─── RAW PALETTE (private — never use in widgets) ──────────────────────────

  static const Color _blue600    = Color(0xFF2563EB); // client primary
  static const Color _blue500    = Color(0xFF3B82F6); // operator primary
  static const Color _warmWhite  = Color(0xFFFAF9F7);
  static const Color _gray50     = Color(0xFFF5F4F2);
  static const Color _gray100    = Color(0xFFE8E6E3);
  static const Color _gray400    = Color(0xFF9CA3AF);
  static const Color _gray600    = Color(0xFF4B5563);
  static const Color _gray900    = Color(0xFF111111);
  static const Color _deepBg     = Color(0xFF040713);
  static const Color _cardBg     = Color(0xFF191C28);
  static const Color _elevatedBg = Color(0xFF252834);
  static const Color _textLight  = Color(0xFFEEF0F5);

  // ─── SEMANTIC COLORS (public — for things outside colorScheme) ─────────────

  static const Color starColor    = Color(0xFFFACC15);
  static const Color successColor = Color(0xFF22C55E);
  static const Color errorColor   = Color(0xFFEF4444);

  // ─── COLOR SCHEMES ─────────────────────────────────────────────────────────

  static const ColorScheme _clientScheme = ColorScheme.light(
    primary:                 _blue600,
    onPrimary:               Color(0xFFFFFFFF),
    surface:                 _warmWhite,
    onSurface:               _gray900,
    onSurfaceVariant:        _gray600,
    outline:                 _gray100,
    outlineVariant:          _gray50,
    surfaceContainerHighest: _gray50,
    error:                   errorColor,
    onError:                 Color(0xFFFFFFFF),
  );

  static const ColorScheme _operatorScheme = ColorScheme.dark(
    primary:                 _blue500,
    onPrimary:               Color(0xFFFFFFFF),
    surface:                 _deepBg,
    onSurface:               _textLight,
    onSurfaceVariant:        _gray400,
    outline:                 Color(0x1AFFFFFF),
    outlineVariant:          Color(0x0DFFFFFF),
    surfaceContainerHighest: _cardBg,
    surfaceContainer:        _elevatedBg,
    error:                   errorColor,
    onError:                 Color(0xFFFFFFFF),
  );

  // ─── SPACING ───────────────────────────────────────────────────────────────
  // Never hardcode padding values in widgets — always use these.

  static const double space2  = 2.0;
  static const double space4  = 4.0;
  static const double space6  = 6.0;
  static const double space8  = 8.0;
  static const double space12 = 12.0;
  static const double space14 = 14.0;
  static const double space16 = 16.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space48 = 48.0;

  // ─── BORDER RADIUS ─────────────────────────────────────────────────────────

  static const double rounded4  = 4.0;
  static const double rounded6  = 6.0;
  static const double rounded8  = 8.0;
  static const double rounded10 = 10.0;
  static const double rounded12 = 12.0;
  static const double rounded16 = 16.0;
  static const double rounded32 = 32.0;
  static const double rounded40 = 40.0;

  // ─── TYPOGRAPHY ────────────────────────────────────────────────────────────
  // Raw styles — no color applied here.
  // Color is applied in _buildTextTheme() via colorScheme.
  //
  // Scale (mobile only — iOS + Android):
  //   h1  28px — screen/hero titles
  //   h2  22px — section headers ("Glide In Marrakech")
  //   h3  18px — modal titles, detail screen headers
  //   body 16px — ALL reading contexts: forms, descriptions, inputs
  //   sm  14px — category tabs, search placeholder, nav labels
  //   xs  12px — card titles on browse screens ONLY (scan context)
  //   xxs 11px — price, rating, secondary metadata
  //   badge 8px — badge labels ONLY ("Insured", "Verified") — single word, pill bg

  static final TextStyle h1 = GoogleFonts.geist(
    fontSize: 28, fontWeight: FontWeight.w600, letterSpacing: -0.3);

  static final TextStyle h2 = GoogleFonts.geist(
    fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: -0.2);

  static final TextStyle h3 = GoogleFonts.geist(
    fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.1);

  static final TextStyle body = GoogleFonts.geist(
    fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0);

  static final TextStyle bodyMedium = GoogleFonts.geist(
    fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0);

  static final TextStyle sm = GoogleFonts.geist(
    fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0);

  static final TextStyle smMedium = GoogleFonts.geist(
    fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0);

  static final TextStyle xs = GoogleFonts.geist(
    fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0);

  static final TextStyle xsMedium = GoogleFonts.geist(
    fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0);

  static final TextStyle xxs = GoogleFonts.geist(
    fontSize: 11, fontWeight: FontWeight.w400, letterSpacing: 0);

  static final TextStyle badge = GoogleFonts.geist(
    fontSize: 8, fontWeight: FontWeight.w600, letterSpacing: 0.3);
  // badge: single-word pill labels only ("Insured", "Verified")
  // Never use for anything the user needs to read

  // ─── THEME DATA ────────────────────────────────────────────────────────────

  /// Light theme — client-facing side of Atlas
  static ThemeData clientTheme() => ThemeData(
    colorScheme:             _clientScheme,
    useMaterial3:            true,
    scaffoldBackgroundColor: _clientScheme.surface,
    textTheme:               _buildTextTheme(_clientScheme),
  );

  /// Dark theme — operator-facing side of Atlas
  static ThemeData operatorTheme() => ThemeData(
    colorScheme:             _operatorScheme,
    useMaterial3:            true,
    scaffoldBackgroundColor: _operatorScheme.surface,
    textTheme:               _buildTextTheme(_operatorScheme),
  );

  // ─── TEXT THEME BUILDER ────────────────────────────────────────────────────
  // Maps Atlas type scale → Material TextTheme slots.
  // Widgets consume via Theme.of(context).textTheme.* — never AppTheme.h1 directly.

  static TextTheme _buildTextTheme(ColorScheme cs) => TextTheme(
    // Display slots → headings
    displayLarge:   h1.copyWith(color: cs.onSurface),
    displayMedium:  h2.copyWith(color: cs.onSurface),
    displaySmall:   h3.copyWith(color: cs.onSurface),
    // Title slots → body reading contexts
    titleLarge:     bodyMedium.copyWith(color: cs.onSurface),
    titleMedium:    smMedium.copyWith(color: cs.onSurface),
    titleSmall:     xsMedium.copyWith(color: cs.onSurface),
    // Body slots → primary content
    bodyLarge:      body.copyWith(color: cs.onSurface),
    bodyMedium:     sm.copyWith(color: cs.onSurface),
    bodySmall:      xs.copyWith(color: cs.onSurfaceVariant),
    // Label slots → metadata, badges, captions
    labelLarge:     smMedium.copyWith(color: cs.onSurface),
    labelMedium:    xxs.copyWith(color: cs.onSurfaceVariant),
    labelSmall:     badge.copyWith(color: cs.onSurfaceVariant),
  );

  // ─── BUTTON STYLES ─────────────────────────────────────────────────────────
  // Always read from colorScheme — never hardcode colors.

  static ButtonStyle primaryButton(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextButton.styleFrom(
      backgroundColor: cs.primary,
      foregroundColor: cs.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(rounded8)),
      textStyle: smMedium,
      padding: const EdgeInsets.symmetric(
        horizontal: space16, vertical: space12),
    );
  }

  static ButtonStyle pillButton(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextButton.styleFrom(
      backgroundColor: cs.onSurface,
      foregroundColor: cs.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(99)),
      textStyle: smMedium,
      padding: const EdgeInsets.symmetric(
        horizontal: space24, vertical: space8),
    );
  }

  static ButtonStyle pillButtonPrimary(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextButton.styleFrom(
      backgroundColor: cs.primary,
      foregroundColor: cs.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(99)),
      textStyle: smMedium,
      padding: const EdgeInsets.symmetric(
        horizontal: space24, vertical: space8),
    );
  }
}