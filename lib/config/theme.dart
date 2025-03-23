import 'package:flutter/material.dart';

/// Styles for the application.
///
/// Contains static methods for standard text styles.
abstract final class Styles {
  static const title = _h1;
  static const subtitle = _h2;
  static const minititle = _h3;
  static const body = _p1;
  static final chip = _b2;
  static final metadata = _p2;
  static final button = _b1;

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

  static final _p2 = TextStyle(
    color: Colors.grey.shade400,
    letterSpacing: -0.5,
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );

  static final _b1 = TextStyle(
    color: Colors.white,
    letterSpacing: -0.5,
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );

  static final _b2 = TextStyle(color: Colors.grey.shade600);
}

/// Defines the app colours.
extension Colours on Colors {
  static const primary = Colors.black;
  static final secondary = Colors.grey.shade300;
  static final divider = Colors.grey.shade200;
  static final chipBorder = Colors.grey.shade300;
  static final icon = Colors.grey.shade400;
  static final iconButton = Colors.grey.shade600;
  static final iconButtonBg = Colors.grey.shade200;
  static const cardBold = Colors.black87;
}

/// Confirguation for the app theme.
abstract class AppTheme {
  /// The default theme.
  static final theme = ThemeData(
    colorScheme: _colorScheme,
    primaryColor: Colours.primary,
    highlightColor: Colors.grey.shade200,
    dividerColor: Colors.transparent,
    splashColor: Colors.transparent,
    cardTheme: _cardTheme,
    chipTheme: _chipTheme,
    bottomSheetTheme: _bottomSheetTheme,
    filledButtonTheme: _filledButtonTheme,
  );

  static final _colorScheme = ColorScheme.fromSeed(
    seedColor: Colours.primary,
    primary: Colours.primary,
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

  static final _filledButtonTheme = FilledButtonThemeData(
    style: ButtonStyle(
      textStyle: WidgetStatePropertyAll(Styles.button),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
  );
}
