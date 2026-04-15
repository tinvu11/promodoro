// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Pomodoro';

  @override
  String get timerTab => 'Timer';

  @override
  String get statisticsTab => 'Statistik';

  @override
  String get settingsTab => 'Inställningar';

  @override
  String get settings => 'Inställningar';

  @override
  String get workTime => 'Fokus';

  @override
  String get breakTime => 'Paus';

  @override
  String get duration => 'Längd';

  @override
  String get focus => 'Fokus';

  @override
  String get rest => 'Vila';

  @override
  String get alarm => 'Alarm';

  @override
  String get volume => 'Volym';

  @override
  String get repeatCount => 'Session';

  @override
  String repeatTimes(int count) {
    return '$count sess';
  }

  @override
  String get repeat => 'Upprepa';

  @override
  String minutes(int count) {
    return '$count min';
  }

  @override
  String get sound => 'Ljud';

  @override
  String get backgroundSound => 'Bakgrundsljud';

  @override
  String get language => 'Språk';

  @override
  String get alwaysOnScreen => 'Alltid på';

  @override
  String get information => 'Information';

  @override
  String get work => 'Arbete';

  @override
  String get breakLabel => 'Paus';

  @override
  String get start => 'Starta';

  @override
  String get continueLabel => 'Fortsätt';

  @override
  String get pause => 'Pausa';

  @override
  String get statistics => 'Statistik';

  @override
  String get total => 'Totalt';

  @override
  String get today => 'Idag';

  @override
  String get sessions => 'sessioner';

  @override
  String hoursAndMinutes(int hours, int mins) {
    return '${hours}t ${mins}m';
  }

  @override
  String hoursOnly(int hours) {
    return '${hours}t';
  }

  @override
  String minutesOnly(int mins) {
    return '${mins}m';
  }

  @override
  String totalLabel(String value) {
    return 'Totalt: $value';
  }

  @override
  String get premiumFeatures => 'Premiumfunktioner';

  @override
  String get unlockAllFeatures => 'Lås upp allt';

  @override
  String get noAds => 'Ingen reklam';

  @override
  String get prioritySupport => 'Prioriterad teamsupport';

  @override
  String get optimizePerformance => 'Optimera prestanda';

  @override
  String get lifetime => 'Livstid';

  @override
  String get buyOnce => 'Köp en gång, använd för alltid';

  @override
  String get yearly => 'Årlig';

  @override
  String get save40 => 'Spara 40%';

  @override
  String get terms => 'Användarvillkor';

  @override
  String get restore => 'Återställ';

  @override
  String get policy => 'Integritetspolicy';

  @override
  String get hot => 'HET';

  @override
  String get vietnamese => 'Vietnamesiska';

  @override
  String get english => 'Engelska';

  @override
  String get languageSelection => 'Välj språk';

  @override
  String get noData => 'Ingen data hittades';

  @override
  String get noInternet => 'Ingen internetuppkoppling.';

  @override
  String get tryAgainConnect => 'Försök att ansluta igen.';

  @override
  String get tryAgain => 'Försök igen';

  @override
  String get sponsored => 'Sponsrad';

  @override
  String get stop_timer_title => 'Stoppa timern';

  @override
  String get stop_timer_content =>
      'Vänligen stoppa timern innan du ändrar inställningarna.';

  @override
  String get btn_stop => 'Stoppa';

  @override
  String get btn_cancel => 'Avbryt';

  @override
  String get version => 'Version';

  @override
  String get email => 'E-post';

  @override
  String get share => 'Dela';

  @override
  String get rate => 'Betygsätt';

  @override
  String get term_pw => 'Villkor';

  @override
  String get policy_pw => 'Policy';
}
