import 'package:gap/gap.dart';

/// Spacers for within list [Widget]s.
/// e.g. [Row]s and [Column]s.
///
/// Use instead of [SizedBox].
///
/// Follows a scale based on the 8-point grid system.
abstract final class Spacing {
  static const s2 = Gap(2);
  static const s4 = Gap(4);
  static const s8 = Gap(8);
  static const s12 = Gap(12);
  static const s16 = Gap(16);
  static const s20 = Gap(20);
  static const s24 = Gap(24);
  static const s32 = Gap(32);
  static const s40 = Gap(40);
  static const s48 = Gap(48);
  static const s64 = Gap(64);
  static const s128 = Gap(128);
}
