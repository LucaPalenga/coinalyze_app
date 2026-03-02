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

  @override
  String get select_asset => 'Seleziona asset';

  @override
  String get chart_open_interest => 'Open Interest';

  @override
  String get chart_funding_rate => 'Funding Rate';

  @override
  String get chart_liquidations => 'Liquidazioni';

  @override
  String get chart_long_short_ratio => 'Rapporto Long/Short';

  @override
  String get secondary_chart_not_available =>
      'Dati non disponibili per questo indicatore';

  @override
  String get longs => 'Longs';

  @override
  String get shorts => 'Shorts';

  @override
  String get ratio => 'Rapporto';

  @override
  String get search_assets => 'Cerca asset...';

  @override
  String get no_assets_found => 'Nessun asset trovato';

  @override
  String get perpetual => 'Perpetuo';

  @override
  String get loading_assets => 'Caricamento asset...';

  @override
  String get select_interval => 'Seleziona intervallo';

  @override
  String get select_chart_type => 'Seleziona tipo di grafico';
}
