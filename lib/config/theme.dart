import 'package:flutter/material.dart';

/// Styles for the application.
///
/// Contains static methods for standard text styles.
abstract final class Styles {
  static const title = _h1;
  static const subtitle = _h2;
  static const minititle = _h3;
  static const body = _p1;

  static const _h1 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 24,
    letterSpacing: -1.0,
    height: 1.2,
  );

  static const _h2 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 22,
    letterSpacing: -1.0,
    height: 1.2,
  );

  static const _h3 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    letterSpacing: -1.0,
    height: 1.2,
  );

  static const _p1 = TextStyle(
    letterSpacing: -0.5,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.2,
  );
}

/// Confirguation for the app theme.
abstract class AppTheme {
  /// The default theme.
  static final theme = ThemeData(
    colorScheme: _colorScheme,
    primaryColor: Colors.black,
    highlightColor: Colors.grey.shade200,
    cardTheme: _cardTheme,
    chipTheme: _chipTheme,
    bottomSheetTheme: _bottomSheetTheme,
  );

  static final _colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.black,
    primary: Colors.black,
    secondary: Colors.grey.shade300,
  );

  static final _cardTheme = CardTheme(
    color: Colors.grey.shade50,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );

  static final _chipTheme = ChipThemeData(
    backgroundColor: Colors.transparent,
    selectedColor: Colors.black87,
    shadowColor: Colors.black45,
    selectedShadowColor: Colors.black45,
    surfaceTintColor: Colors.black45,
    showCheckmark: false,
    secondaryLabelStyle: TextStyle(
      color: Colors.white,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(100),
    ),
  );

  static final _bottomSheetTheme = BottomSheetThemeData(
    backgroundColor: Colors.transparent,
  );
}
