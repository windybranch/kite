import 'package:flutter/widgets.dart';

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
