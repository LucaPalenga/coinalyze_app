import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme createTextTheme(BuildContext context, String bodyFontString, String displayFontString) {
  TextTheme baseTextTheme = Theme.of(context).textTheme;
  TextTheme bodyTextTheme = GoogleFonts.getTextTheme(bodyFontString, baseTextTheme);
  TextTheme displayTextTheme = GoogleFonts.getTextTheme(displayFontString, baseTextTheme);
  TextTheme textTheme = displayTextTheme.copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );
  return _applyTabularFigures(textTheme);
}

TextTheme _applyTabularFigures(TextTheme textTheme) {
  const fontFeatures = [FontFeature.tabularFigures()];
  return TextTheme(
    displayLarge: textTheme.displayLarge?.copyWith(fontFeatures: fontFeatures),
    displayMedium: textTheme.displayMedium?.copyWith(fontFeatures: fontFeatures),
    displaySmall: textTheme.displaySmall?.copyWith(fontFeatures: fontFeatures),
    headlineLarge: textTheme.headlineLarge?.copyWith(fontFeatures: fontFeatures),
    headlineMedium: textTheme.headlineMedium?.copyWith(fontFeatures: fontFeatures),
    headlineSmall: textTheme.headlineSmall?.copyWith(fontFeatures: fontFeatures),
    titleLarge: textTheme.titleLarge?.copyWith(fontFeatures: fontFeatures),
    titleMedium: textTheme.titleMedium?.copyWith(fontFeatures: fontFeatures),
    titleSmall: textTheme.titleSmall?.copyWith(fontFeatures: fontFeatures),
    bodyLarge: textTheme.bodyLarge?.copyWith(fontFeatures: fontFeatures),
    bodyMedium: textTheme.bodyMedium?.copyWith(fontFeatures: fontFeatures),
    bodySmall: textTheme.bodySmall?.copyWith(fontFeatures: fontFeatures),
    labelLarge: textTheme.labelLarge?.copyWith(fontFeatures: fontFeatures),
    labelMedium: textTheme.labelMedium?.copyWith(fontFeatures: fontFeatures),
    labelSmall: textTheme.labelSmall?.copyWith(fontFeatures: fontFeatures),
  );
}
