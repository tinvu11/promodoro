// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Pomodoro';

  @override
  String get timerTab => 'Timer';

  @override
  String get statisticsTab => 'Statistieken';

  @override
  String get settingsTab => 'Instellingen';

  @override
  String get settings => 'Instellingen';

  @override
  String get workTime => 'Focus';

  @override
  String get breakTime => 'Pauze';

  @override
  String get duration => 'Duur';

  @override
  String get focus => 'Focus';

  @override
  String get rest => 'Rust';

  @override
  String get alarm => 'Alarm';

  @override
  String get volume => 'Volume';

  @override
  String get repeatCount => 'Sessie';

  @override
  String repeatTimes(int count) {
    return '$count sessies';
  }

  @override
  String get repeat => 'Herhalen';

  @override
  String minutes(int count) {
    return '$count min';
  }

  @override
  String get sound => 'Geluid';

  @override
  String get backgroundSound => 'Achtergrondgeluid';

  @override
  String get language => 'Taal';

  @override
  String get alwaysOnScreen => 'Altijd aan';

  @override
  String get information => 'Informatie';

  @override
  String get work => 'Werk';

  @override
  String get breakLabel => 'Pauze';

  @override
  String get start => 'Start';

  @override
  String get continueLabel => 'Doorgaan';

  @override
  String get pause => 'Pauze';

  @override
  String get statistics => 'Statistieken';

  @override
  String get total => 'Totaal';

  @override
  String get today => 'Vandaag';

  @override
  String get sessions => 'sessies';

  @override
  String hoursAndMinutes(int hours, int mins) {
    return '${hours}u ${mins}m';
  }

  @override
  String hoursOnly(int hours) {
    return '${hours}h';
  }

  @override
  String minutesOnly(int mins) {
    return '${mins}m';
  }

  @override
  String totalLabel(String value) {
    return 'Totaal: $value';
  }

  @override
  String get premiumFeatures => 'Premium functies';

  @override
  String get unlockAllFeatures => 'Ontgrendel alles';

  @override
  String get noAds => 'Geen advertenties';

  @override
  String get prioritySupport => 'Priority team support';

  @override
  String get optimizePerformance => 'Optimize performance';

  @override
  String get lifetime => 'Levenslang';

  @override
  String get buyOnce => 'Buy once, use forever';

  @override
  String get yearly => 'Jaarlijks';

  @override
  String get save40 => 'Bespaar 40%';

  @override
  String get terms => 'Voorwaarden';

  @override
  String get restore => 'Herstellen';

  @override
  String get policy => 'Beleid';

  @override
  String get hot => 'HOT';

  @override
  String get vietnamese => 'Vietnamees';

  @override
  String get english => 'Engels';

  @override
  String get languageSelection => 'Kies taal';
}
