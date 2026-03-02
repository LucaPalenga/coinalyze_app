/// Defines all possible size of the icons in the app,
/// following the Material 2021 guidelines.
/// Docs: https://m3.material.io/styles/icons/designing-icons
final class IconSize {
  /// A very very small icon.
  /// Valentina's icon size.
  static const double smallest = 16;

  /// A very small icon.
  static const double smaller = 20;

  /// A medium icon. This is the default size of icons.
  static const double medium = 24;

  /// A large icon.
  static const double large = 32;

  /// A very large icon.
  static const double larger = 40;
}

/// Defines all possible padding sizes in the app,
/// following the Material 2021 guidelines.
/// Docs: https://m3.material.io/foundations/layout/understanding-layout/spacing
final class PaddingSize {
  // These factors are modifiable
  static const double _paddingSmallerSizeFactor = 1;
  static const double _paddingSmallSizeFactor = 2;
  static const double _paddingMediumSizeFactor = 3;
  static const double _paddingLargeSizeFactor = 4;
  static const double _paddingLargerSizeFactor = 5;

  // CHANGES TO THESE VALUE GO AGAINST THE MATERIAL DESIGN 2021 GUIDELINES
  /// A very small padding (4).
  static const double smaller = _paddingBaseSize * _paddingSmallerSizeFactor;

  /// A small padding (8).
  static const double small = _paddingBaseSize * _paddingSmallSizeFactor;

  /// A medium padding (12).
  static const double medium = _paddingBaseSize * _paddingMediumSizeFactor;

  /// A large padding (16).
  static const double large = _paddingBaseSize * _paddingLargeSizeFactor;

  /// A very large padding (20).
  static const double larger = _paddingBaseSize * _paddingLargerSizeFactor;

  // CHANGES TO THIS VALUE GO AGAINST THE MATERIAL DESIGN 2021 GUIDELINES
  static const double _paddingBaseSize = 4;
}
