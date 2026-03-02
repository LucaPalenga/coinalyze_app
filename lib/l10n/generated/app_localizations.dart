import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Coinalyze'**
  String get app_title;

  /// Error message shown when data fails to load
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get error_loading_data;

  /// Retry button label
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Message shown when there is no data to display
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get no_data_available;

  /// Message shown when Open Interest data is not available
  ///
  /// In en, this message translates to:
  /// **'Open Interest not available'**
  String get open_interest_not_available;

  /// Label for the aggregated open interest chart section
  ///
  /// In en, this message translates to:
  /// **'Aggregated Open Interest'**
  String get aggregated_open_interest;

  /// OHLC Open label
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// OHLC High label
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// OHLC Low label
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// OHLC Close label
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Volume label
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volume;

  /// Title shown when a network error occurs
  ///
  /// In en, this message translates to:
  /// **'Connection error'**
  String get error_network_title;

  /// Message shown when a network error occurs
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to the server. Check your internet connection and try again.'**
  String get error_network_message;

  /// Title shown when a server error occurs
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get error_server_title;

  /// Title shown when the API key is invalid
  ///
  /// In en, this message translates to:
  /// **'Authentication error'**
  String get error_unauthorized_title;

  /// Message shown when the API key is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid or missing API key. Please check your configuration.'**
  String get error_unauthorized_message;

  /// Title shown when rate limit is exceeded
  ///
  /// In en, this message translates to:
  /// **'Too many requests'**
  String get error_rate_limit_title;

  /// Message shown when rate limit is exceeded
  ///
  /// In en, this message translates to:
  /// **'You have exceeded the request limit. Please wait a moment and try again.'**
  String get error_rate_limit_message;

  /// Generic error title
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get error_generic_title;

  /// Title for the asset selection dialog
  ///
  /// In en, this message translates to:
  /// **'Select asset'**
  String get select_asset;

  /// Label for the Open Interest chart type
  ///
  /// In en, this message translates to:
  /// **'Open Interest'**
  String get chart_open_interest;

  /// Label for the Funding Rate chart type
  ///
  /// In en, this message translates to:
  /// **'Funding Rate'**
  String get chart_funding_rate;

  /// Label for the Liquidations chart type
  ///
  /// In en, this message translates to:
  /// **'Liquidations'**
  String get chart_liquidations;

  /// Label for the Long/Short Ratio chart type
  ///
  /// In en, this message translates to:
  /// **'Long/Short Ratio'**
  String get chart_long_short_ratio;

  /// Message shown when secondary chart data is not available
  ///
  /// In en, this message translates to:
  /// **'No data available for this indicator'**
  String get secondary_chart_not_available;

  /// Longs label for liquidations
  ///
  /// In en, this message translates to:
  /// **'Longs'**
  String get longs;

  /// Shorts label for liquidations
  ///
  /// In en, this message translates to:
  /// **'Shorts'**
  String get shorts;

  /// Ratio label for long/short ratio
  ///
  /// In en, this message translates to:
  /// **'Ratio'**
  String get ratio;

  /// Hint text for the asset search field
  ///
  /// In en, this message translates to:
  /// **'Search assets...'**
  String get search_assets;

  /// Message shown when search yields no results
  ///
  /// In en, this message translates to:
  /// **'No assets found'**
  String get no_assets_found;

  /// Label for perpetual contract type
  ///
  /// In en, this message translates to:
  /// **'Perpetual'**
  String get perpetual;

  /// Message shown while loading the asset list
  ///
  /// In en, this message translates to:
  /// **'Loading assets...'**
  String get loading_assets;

  /// Title for the time interval selection dialog
  ///
  /// In en, this message translates to:
  /// **'Select interval'**
  String get select_interval;

  /// Title for the secondary chart type selection dialog
  ///
  /// In en, this message translates to:
  /// **'Select chart type'**
  String get select_chart_type;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
