import 'package:coinalyze_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

/// Adds a set of utility methods on [BuildContext].
extension BuildContextControls on BuildContext {
  /// Check wherever the application is on dark mode or not.
  ///
  /// The ThemeMode of an application may be [ThemeMode.system],
  /// [ThemeMode.dark] and [ThemeMode.light]. However the [ThemeMode.system]
  /// can be either dark or light based on the local configuration of the
  /// device of the user.
  ///
  /// A [ThemeData] object created with the **ThemeData.from()**
  /// constructor has an official way to know if the theme is on
  /// dark mode, checking the brightness property of its
  /// colorScheme property.
  bool get isDarkMode => Theme.of(this).colorScheme.brightness == Brightness.dark;

  /// Returns the [AppLocalizations] instance with localized strings.
  ///
  /// This reduces the boilerplate code needed
  /// to localize the text in the app.
  ///
  /// Rather than writing...
  ///
  /// ```dart
  /// final text = AppLocalizations.of(context).appTitle;
  /// ```
  ///
  /// ... you should use this shorter syntax:
  ///
  /// ```dart
  /// final text = context.l10n.appTitle;
  /// ```
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Returns the current [Orientation] instance of the context.
  ///
  /// This reduces the boilerplate code needed
  /// to obtain the current orientation of the device.
  ///
  /// Rather than writing...
  ///
  /// ```dart
  /// final orientation = MediaQuery.of(context).orientation;
  /// ```
  ///
  /// ... you should use this shorter syntax:
  ///
  /// ```dart
  /// final orientation = context.orientation;
  /// ```
  Orientation get orientation {
    final size = MediaQuery.sizeOf(this);
    return size.height > size.width ? Orientation.portrait : Orientation.landscape;
  }

  /// Returns the current [ColorScheme] instance of the context.
  ///
  /// This reduces the boilerplate code needed
  /// to obtain the current color scheme.
  ///
  /// Rather than writing...
  ///
  /// ```dart
  /// final color = Theme.of(context).colorScheme.primaryColor;
  /// ```
  ///
  /// ... you should use this shorter syntax:
  ///
  /// ```dart
  /// final color = context.colorScheme.primaryColor;
  /// ```
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Returns the current [TextTheme] instance of the context.
  ///
  /// This reduces the boilerplate code needed
  /// to obtain the current text theme.
  ///
  /// Rather than writing...
  ///
  /// ```dart
  /// final color = Theme.of(context).textTheme.bodyMedium;
  /// ```
  ///
  /// ... you should use this shorter syntax:
  ///
  /// ```dart
  /// final color = context.textTheme.bodyMedium;
  /// ```
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Whether a modal route is open.
  bool get hasDialogOpen => ModalRoute.of(this)?.isCurrent != true;

  /// Whether the user is using an accessibility service like
  /// TalkBack or VoiceOver to interact with the application.
  bool get isAccessibleNavigationEnabled => MediaQuery.accessibleNavigationOf(this);
}
