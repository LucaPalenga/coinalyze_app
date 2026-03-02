// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get app_title => 'Coinalyze';

  @override
  String get error_loading_data => 'Errore nel caricamento dei dati';

  @override
  String get retry => 'Riprova';

  @override
  String get no_data_available => 'Nessun dato disponibile';

  @override
  String get open_interest_not_available => 'Open Interest non disponibile';

  @override
  String get aggregated_open_interest => 'Open Interest Aggregato';

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

  @override
  String get error_network_title => 'Errore di connessione';

  @override
  String get error_network_message =>
      'Impossibile connettersi al server. Controlla la tua connessione internet e riprova.';

  @override
  String get error_server_title => 'Errore del server';

  @override
  String get error_unauthorized_title => 'Errore di autenticazione';

  @override
  String get error_unauthorized_message =>
      'API key non valida o mancante. Verifica la configurazione.';

  @override
  String get error_rate_limit_title => 'Troppe richieste';

  @override
  String get error_rate_limit_message =>
      'Hai superato il limite di richieste. Attendi un momento e riprova.';

  @override
  String get error_generic_title => 'Qualcosa è andato storto';
}
