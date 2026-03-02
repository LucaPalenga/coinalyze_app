// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Coinalyze';

  @override
  String get errorLoadingData => 'Errore nel caricamento dei dati';

  @override
  String get retry => 'Riprova';

  @override
  String get noDataAvailable => 'Nessun dato disponibile';

  @override
  String get openInterestNotAvailable => 'Open Interest non disponibile';

  @override
  String get aggregatedOpenInterest => 'Open Interest Aggregato';

  @override
  String get open => 'Apertura';

  @override
  String get high => 'Massimo';

  @override
  String get low => 'Minimo';

  @override
  String get close => 'Chiusura';

  @override
  String get volume => 'Volume';
}
