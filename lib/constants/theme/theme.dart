import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff4648d4),
      surfaceTint: Color(0xff494bd6),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff6063ee),
      onPrimaryContainer: Color(0xfffffbff),
      secondary: Color(0xff575992),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffbdbefe),
      onSecondaryContainer: Color(0xff494b83),
      tertiary: Color(0xff972b99),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffb547b4),
      onTertiaryContainer: Color(0xfffffbff),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffcf8ff),
      onSurface: Color(0xff1b1b23),
      onSurfaceVariant: Color(0xff464554),
      outline: Color(0xff767586),
      outlineVariant: Color(0xffc7c4d7),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303038),
      inversePrimary: Color(0xffc0c1ff),
      primaryFixed: Color(0xffe1e0ff),
      onPrimaryFixed: Color(0xff07006c),
      primaryFixedDim: Color(0xffc0c1ff),
      onPrimaryFixedVariant: Color(0xff2f2ebe),
      secondaryFixed: Color(0xffe1e0ff),
      onSecondaryFixed: Color(0xff13144a),
      secondaryFixedDim: Color(0xffc0c1ff),
      onSecondaryFixedVariant: Color(0xff404178),
      tertiaryFixed: Color(0xffffd6f7),
      onTertiaryFixed: Color(0xff37003a),
      tertiaryFixedDim: Color(0xffffaaf7),
      onTertiaryFixedVariant: Color(0xff7e0a81),
      surfaceDim: Color(0xffdbd8e4),
      surfaceBright: Color(0xfffcf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff5f2fe),
      surfaceContainer: Color(0xffefecf8),
      surfaceContainerHigh: Color(0xffe9e6f3),
      surfaceContainerHighest: Color(0xffe4e1ed),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff1911af),
      surfaceTint: Color(0xff494bd6),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff585be6),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff2f3066),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff6668a2),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff640067),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffac3fac),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffcf8ff),
      onSurface: Color(0xff101018),
      onSurfaceVariant: Color(0xff353543),
      outline: Color(0xff515160),
      outlineVariant: Color(0xff6c6b7c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303038),
      inversePrimary: Color(0xffc0c1ff),
      primaryFixed: Color(0xff585be6),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff3e3fcc),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff6668a2),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff4e4f87),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xffac3fac),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff8f2291),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc7c5d1),
      surfaceBright: Color(0xfffcf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff5f2fe),
      surfaceContainer: Color(0xffe9e6f3),
      surfaceContainerHigh: Color(0xffdedbe7),
      surfaceContainerHighest: Color(0xffd3d0dc),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff0e009d),
      surfaceTint: Color(0xff494bd6),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff3131c1),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff24265c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff42447b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff530056),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff811084),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffcf8ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff2b2b39),
      outlineVariant: Color(0xff484857),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303038),
      inversePrimary: Color(0xffc0c1ff),
      primaryFixed: Color(0xff3131c1),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff1406ac),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff42447b),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff2b2d63),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff811084),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff5e0061),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffbab7c3),
      surfaceBright: Color(0xfffcf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2effb),
      surfaceContainer: Color(0xffe4e1ed),
      surfaceContainerHigh: Color(0xffd6d3df),
      surfaceContainerHighest: Color(0xffc7c5d1),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffc0c1ff),
      surfaceTint: Color(0xffc0c1ff),
      onPrimary: Color(0xff1000a9),
      primaryContainer: Color(0xff8083ff),
      onPrimaryContainer: Color(0xff01002b),
      secondary: Color(0xffc0c1ff),
      onSecondary: Color(0xff292a60),
      secondaryContainer: Color(0xff42447b),
      onSecondaryContainer: Color(0xffb2b3f2),
      tertiary: Color(0xffffaaf7),
      onTertiary: Color(0xff5a005d),
      tertiaryContainer: Color(0xffd664d3),
      onTertiaryContainer: Color(0xff120013),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff13131b),
      onSurface: Color(0xffe4e1ed),
      onSurfaceVariant: Color(0xffc7c4d7),
      outline: Color(0xff908fa0),
      outlineVariant: Color(0xff464554),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe4e1ed),
      inversePrimary: Color(0xff494bd6),
      primaryFixed: Color(0xffe1e0ff),
      onPrimaryFixed: Color(0xff07006c),
      primaryFixedDim: Color(0xffc0c1ff),
      onPrimaryFixedVariant: Color(0xff2f2ebe),
      secondaryFixed: Color(0xffe1e0ff),
      onSecondaryFixed: Color(0xff13144a),
      secondaryFixedDim: Color(0xffc0c1ff),
      onSecondaryFixedVariant: Color(0xff404178),
      tertiaryFixed: Color(0xffffd6f7),
      onTertiaryFixed: Color(0xff37003a),
      tertiaryFixedDim: Color(0xffffaaf7),
      onTertiaryFixedVariant: Color(0xff7e0a81),
      surfaceDim: Color(0xff13131b),
      surfaceBright: Color(0xff393841),
      surfaceContainerLowest: Color(0xff0d0d15),
      surfaceContainerLow: Color(0xff1b1b23),
      surfaceContainer: Color(0xff1f1f27),
      surfaceContainerHigh: Color(0xff292932),
      surfaceContainerHighest: Color(0xff34343d),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffdad9ff),
      surfaceTint: Color(0xffc0c1ff),
      onPrimary: Color(0xff0b008a),
      primaryContainer: Color(0xff8083ff),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffdad9ff),
      onSecondary: Color(0xff1e1f55),
      secondaryContainer: Color(0xff8a8bc8),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffcdf7),
      onTertiary: Color(0xff48004b),
      tertiaryContainer: Color(0xffd664d3),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff13131b),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffdddaed),
      outline: Color(0xffb2b0c2),
      outlineVariant: Color(0xff908fa0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe4e1ed),
      inversePrimary: Color(0xff302fbf),
      primaryFixed: Color(0xffe1e0ff),
      onPrimaryFixed: Color(0xff03004d),
      primaryFixedDim: Color(0xffc0c1ff),
      onPrimaryFixedVariant: Color(0xff1911af),
      secondaryFixed: Color(0xffe1e0ff),
      onSecondaryFixed: Color(0xff070641),
      secondaryFixedDim: Color(0xffc0c1ff),
      onSecondaryFixedVariant: Color(0xff2f3066),
      tertiaryFixed: Color(0xffffd6f7),
      onTertiaryFixed: Color(0xff260028),
      tertiaryFixedDim: Color(0xffffaaf7),
      onTertiaryFixedVariant: Color(0xff640067),
      surfaceDim: Color(0xff13131b),
      surfaceBright: Color(0xff44434d),
      surfaceContainerLowest: Color(0xff07070e),
      surfaceContainerLow: Color(0xff1d1d25),
      surfaceContainer: Color(0xff272730),
      surfaceContainerHigh: Color(0xff32323b),
      surfaceContainerHighest: Color(0xff3d3d46),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff1eeff),
      surfaceTint: Color(0xffc0c1ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffbcbdff),
      onPrimaryContainer: Color(0xff01002b),
      secondary: Color(0xfff1eeff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffbcbdfd),
      onSecondaryContainer: Color(0xff02003c),
      tertiary: Color(0xffffeaf8),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffffa3f7),
      onTertiaryContainer: Color(0xff120013),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff13131b),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xfff1eeff),
      outlineVariant: Color(0xffc3c1d3),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe4e1ed),
      inversePrimary: Color(0xff302fbf),
      primaryFixed: Color(0xffe1e0ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffc0c1ff),
      onPrimaryFixedVariant: Color(0xff03004d),
      secondaryFixed: Color(0xffe1e0ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffc0c1ff),
      onSecondaryFixedVariant: Color(0xff070641),
      tertiaryFixed: Color(0xffffd6f7),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffffaaf7),
      onTertiaryFixedVariant: Color(0xff260028),
      surfaceDim: Color(0xff13131b),
      surfaceBright: Color(0xff504f59),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1f1f27),
      surfaceContainer: Color(0xff303038),
      surfaceContainerHigh: Color(0xff3b3a44),
      surfaceContainerHighest: Color(0xff46464f),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
