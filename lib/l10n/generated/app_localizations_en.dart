// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Coinalyze';

  @override
  String get errorLoadingData => 'Error loading data';

  @override
  String get retry => 'Retry';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get openInterestNotAvailable => 'Open Interest not available';

  @override
  String get aggregatedOpenInterest => 'Aggregated Open Interest';

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
}
