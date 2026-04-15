// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Pomodoro';

  @override
  String get timerTab => 'Timer';

  @override
  String get statisticsTab => 'Statistiche';

  @override
  String get settingsTab => 'Impostazioni';

  @override
  String get settings => 'Impostazioni';

  @override
  String get workTime => 'Focus';

  @override
  String get breakTime => 'Pausa';

  @override
  String get duration => 'Durata';

  @override
  String get focus => 'Focus';

  @override
  String get rest => 'Riposo';

  @override
  String get alarm => 'Sveglia';

  @override
  String get volume => 'Volume';

  @override
  String get repeatCount => 'Sessione';

  @override
  String repeatTimes(int count) {
    return '$count sess';
  }

  @override
  String get repeat => 'Ripeti';

  @override
  String minutes(int count) {
    return '$count min';
  }

  @override
  String get sound => 'Suono';

  @override
  String get backgroundSound => 'Suono di sottofondo';

  @override
  String get language => 'Lingua';

  @override
  String get alwaysOnScreen => 'Sempre attivo';

  @override
  String get information => 'Informazioni';

  @override
  String get work => 'Lavoro';

  @override
  String get breakLabel => 'Pausa';

  @override
  String get start => 'Inizia';

  @override
  String get continueLabel => 'Continua';

  @override
  String get pause => 'Pausa';

  @override
  String get statistics => 'Statistiche';

  @override
  String get total => 'Totale';

  @override
  String get today => 'Oggi';

  @override
  String get sessions => 'sessioni';

  @override
  String hoursAndMinutes(int hours, int mins) {
    return '${hours}h ${mins}m';
  }

  @override
  String hoursOnly(int hours) {
    return '$hours h';
  }

  @override
  String minutesOnly(int mins) {
    return '$mins m';
  }

  @override
  String totalLabel(String value) {
    return 'Totale: $value';
  }

  @override
  String get premiumFeatures => 'Funzioni Premium';

  @override
  String get unlockAllFeatures => 'Sblocca tutto';

  @override
  String get noAds => 'Nessuna pubblicità';

  @override
  String get prioritySupport => 'Supporto prioritario del team';

  @override
  String get optimizePerformance => 'Ottimizza le prestazioni';

  @override
  String get lifetime => 'A vita';

  @override
  String get buyOnce => 'Acquista una volta, usa per sempre';

  @override
  String get yearly => 'Annuale';

  @override
  String get save40 => 'Risparmia il 40%';

  @override
  String get terms => 'Termini di utilizzo';

  @override
  String get restore => 'Ripristina';

  @override
  String get policy => 'Informativa sulla privacy';

  @override
  String get hot => 'HOT';

  @override
  String get vietnamese => 'Vietnamita';

  @override
  String get english => 'Inglese';

  @override
  String get languageSelection => 'Lingua';

  @override
  String get noData => 'Nessun dato trovato';

  @override
  String get noInternet => 'Nessuna connessione Internet.';

  @override
  String get tryAgainConnect => 'Prova a connetterti di nuovo.';

  @override
  String get tryAgain => 'Riprova';

  @override
  String get sponsored => 'Sponsorizzato';

  @override
  String get stop_timer_title => 'Ferma il timer';

  @override
  String get stop_timer_content =>
      'Si prega di fermare il timer prima di modificare le impostazioni.';

  @override
  String get btn_stop => 'Ferma';

  @override
  String get btn_cancel => 'Annulla';

  @override
  String get version => 'Versione';

  @override
  String get email => 'Email';

  @override
  String get share => 'Condividi';

  @override
  String get rate => 'Valuta';

  @override
  String get term_pw => 'Termini';

  @override
  String get policy_pw => 'Politica';
}
