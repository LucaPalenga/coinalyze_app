// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'Coinalyze';

  @override
  String get error_loading_data => 'Error loading data';

  @override
  String get retry => 'Retry';

  @override
  String get no_data_available => 'No data available';

  @override
  String get open_interest_not_available => 'Open Interest not available';

  @override
  String get aggregated_open_interest => 'Aggregated Open Interest';

  @override
  String get open => 'Open';

  @override
  String get high => 'High';

  @override
  String get low => 'Low';

  @override
  String get close => 'Close';

  @override
  String get volume => 'Volume';

  @override
  String get error_network_title => 'Connection error';

  @override
  String get error_network_message =>
      'Unable to connect to the server. Check your internet connection and try again.';

  @override
  String get error_server_title => 'Server error';

  @override
  String get error_unauthorized_title => 'Authentication error';

  @override
  String get error_unauthorized_message =>
      'Invalid or missing API key. Please check your configuration.';

  @override
  String get error_rate_limit_title => 'Too many requests';

  @override
  String get error_rate_limit_message =>
      'You have exceeded the request limit. Please wait a moment and try again.';

  @override
  String get error_generic_title => 'Something went wrong';

  @override
  String get select_asset => 'Select asset';

  @override
  String get chart_open_interest => 'Open Interest';

  @override
  String get chart_funding_rate => 'Funding Rate';

  @override
  String get chart_liquidations => 'Liquidations';

  @override
  String get chart_long_short_ratio => 'Long/Short Ratio';

  @override
  String get secondary_chart_not_available =>
      'No data available for this indicator';

  @override
  String get longs => 'Longs';

  @override
  String get shorts => 'Shorts';

  @override
  String get ratio => 'Ratio';

  @override
  String get search_assets => 'Search assets...';

  @override
  String get no_assets_found => 'No assets found';

  @override
  String get perpetual => 'Perpetual';

  @override
  String get loading_assets => 'Loading assets...';

  @override
  String get select_interval => 'Select interval';

  @override
  String get select_chart_type => 'Select chart type';
}
