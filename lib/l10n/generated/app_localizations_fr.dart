// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Pomodoro';

  @override
  String get timerTab => 'Minuteur';

  @override
  String get statisticsTab => 'Statistiques';

  @override
  String get settingsTab => 'Paramètres';

  @override
  String get settings => 'Paramètres';

  @override
  String get workTime => 'Focus';

  @override
  String get breakTime => 'Pause';

  @override
  String get duration => 'Durée';

  @override
  String get focus => 'Focus';

  @override
  String get rest => 'Repos';

  @override
  String get alarm => 'Alarme';

  @override
  String get volume => 'Volume';

  @override
  String get repeatCount => 'Session';

  @override
  String repeatTimes(int count) {
    return '$count ses';
  }

  @override
  String get repeat => 'Répéter';

  @override
  String minutes(int count) {
    return '$count min';
  }

  @override
  String get sound => 'Son';

  @override
  String get backgroundSound => 'Son d\'ambiance';

  @override
  String get language => 'Langue';

  @override
  String get alwaysOnScreen => 'Toujours allumé';

  @override
  String get information => 'Information';

  @override
  String get work => 'Travail';

  @override
  String get breakLabel => 'Pause';

  @override
  String get start => 'Démarrer';

  @override
  String get continueLabel => 'Continuer';

  @override
  String get pause => 'Pause';

  @override
  String get statistics => 'Statistiques';

  @override
  String get total => 'Total';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get sessions => 'sessions';

  @override
  String hoursAndMinutes(int hours, int mins) {
    return '${hours}h ${mins}m';
  }

  @override
  String hoursOnly(int hours) {
    return '${hours}h';
  }

  @override
  String minutesOnly(int mins) {
    return '$mins min';
  }

  @override
  String totalLabel(String value) {
    return 'Total: $value';
  }

  @override
  String get premiumFeatures => 'Fonctions Premium';

  @override
  String get unlockAllFeatures => 'Tout débloquer';

  @override
  String get noAds => 'Sans publicité';

  @override
  String get prioritySupport => 'Accompagnement prioritaire des équipes';

  @override
  String get optimizePerformance => 'Optimiser les performances';

  @override
  String get lifetime => 'À vie';

  @override
  String get buyOnce => 'Achetez une fois, utilisez pour toujours';

  @override
  String get yearly => 'Annuel';

  @override
  String get save40 => 'Économisez 40%';

  @override
  String get terms => 'Conditions d\'utilisation';

  @override
  String get restore => 'Restaurer';

  @override
  String get policy => 'Politique de confidentialité';

  @override
  String get hot => 'HOT';

  @override
  String get vietnamese => 'Vietnamien';

  @override
  String get english => 'Anglais';

  @override
  String get languageSelection => 'Choisir la langue';

  @override
  String get noData => 'Aucune donnée trouvée';

  @override
  String get noInternet => 'Pas de connexion Internet.';

  @override
  String get tryAgainConnect => 'Veuillez réessayer de vous connecter.';

  @override
  String get tryAgain => 'Essayer à nouveau';

  @override
  String get sponsored => 'Sponsorisé';

  @override
  String get stop_timer_title => 'Arrêter le minuteur';

  @override
  String get stop_timer_content =>
      'Veuillez arrêter le minuteur avant de modifier les paramètres.';

  @override
  String get btn_stop => 'Arrêter';

  @override
  String get btn_cancel => 'Annuler';

  @override
  String get version => 'Version';

  @override
  String get email => 'E-mail';

  @override
  String get share => 'Partager';

  @override
  String get rate => 'Évaluer';
}
