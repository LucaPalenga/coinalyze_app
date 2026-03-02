/// Defines all possible icon sizes in the app,
/// following the Material 3 guidelines.
/// Docs: https://m3.material.io/styles/icons/designing-icons
final class IconSize {
  IconSize._();

  /// Extra small icon (12).
  static const double xs = 12;

  /// Smallest icon (16).
  static const double smallest = 16;

  /// Smaller icon (20).
  static const double smaller = 20;

  /// Medium icon (24). This is the default size of icons in Material 3.
  static const double medium = 24;

  /// Large icon (32).
  static const double large = 32;

  /// Larger icon (40).
  static const double larger = 40;

  /// Extra large icon (48).
  static const double xl = 48;
}

/// Defines all possible padding/spacing sizes in the app,
/// following the Material 3 guidelines.
/// Docs: https://m3.material.io/foundations/layout/understanding-layout/spacing
final class SpacingSize {
  SpacingSize._();

  // CHANGES TO THIS VALUE GO AGAINST THE MATERIAL 3 GUIDELINES
  static const double _baseSize = 4;

  /// 2px — hairline spacing.
  static const double xxs = _baseSize * 0.5;

  /// 4px — extra small spacing.
  static const double xs = _baseSize * 1;

  /// 8px — small spacing.
  static const double sm = _baseSize * 2;

  /// 12px — medium spacing.
  static const double md = _baseSize * 3;

  /// 16px — large spacing. Default padding in Material 3.
  static const double lg = _baseSize * 4;

  /// 20px — extra large spacing.
  static const double xl = _baseSize * 5;

  /// 24px — 2x large spacing.
  static const double xxl = _baseSize * 6;

  /// 32px — 3x large spacing.
  static const double xxxl = _baseSize * 8;
}

/// Backward-compatible alias for [SpacingSize].
typedef PaddingSize = SpacingSize;

/// Border radius values following Material 3 shape guidelines.
/// Docs: https://m3.material.io/styles/shape/overview
final class BorderRadiusSize {
  BorderRadiusSize._();

  /// No rounding (0).
  static const double none = 0;

  /// Extra small rounding (4).
  static const double xs = 4;

  /// Small rounding (8).
  static const double sm = 8;

  /// Medium rounding (12). Default for cards and containers.
  static const double md = 12;

  /// Large rounding (16).
  static const double lg = 16;

  /// Extra large rounding (28). Used for FABs and dialogs.
  static const double xl = 28;

  /// Full / circular rounding (100).
  static const double full = 100;
}

/// Elevation levels following Material 3 guidelines.
/// Docs: https://m3.material.io/styles/elevation/overview
final class ElevationSize {
  ElevationSize._();

  /// Level 0 — no elevation (0).
  static const double level0 = 0;

  /// Level 1 — subtle elevation (1).
  static const double level1 = 1;

  /// Level 2 — default card elevation (3).
  static const double level2 = 3;

  /// Level 3 — raised surface (6).
  static const double level3 = 6;

  /// Level 4 — dialogs/modals (8).
  static const double level4 = 8;

  /// Level 5 — highest elevation (12).
  static const double level5 = 12;
}
