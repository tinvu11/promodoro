// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Pomodoro';

  @override
  String get timerTab => 'Timer';

  @override
  String get statisticsTab => 'Statistik';

  @override
  String get settingsTab => 'Einstellungen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get workTime => 'Fokus';

  @override
  String get breakTime => 'Pause';

  @override
  String get duration => 'Dauer';

  @override
  String get focus => 'Fokus';

  @override
  String get rest => 'Pause';

  @override
  String get alarm => 'Alarm';

  @override
  String get volume => 'Lautstärke';

  @override
  String get repeatCount => 'Sitzung';

  @override
  String repeatTimes(int count) {
    return '$count Sitz.';
  }

  @override
  String get repeat => 'Wiederholen';

  @override
  String minutes(int count) {
    return '$count Min';
  }

  @override
  String get sound => 'Ton';

  @override
  String get backgroundSound => 'Hintergrundton';

  @override
  String get language => 'Sprache';

  @override
  String get alwaysOnScreen => 'Immer an';

  @override
  String get information => 'Information';

  @override
  String get work => 'Arbeit';

  @override
  String get breakLabel => 'Pause';

  @override
  String get start => 'Start';

  @override
  String get continueLabel => 'Weiter';

  @override
  String get pause => 'Pause';

  @override
  String get statistics => 'Statistik';

  @override
  String get total => 'Gesamt';

  @override
  String get today => 'Heute';

  @override
  String get sessions => 'Sitzungen';

  @override
  String hoursAndMinutes(int hours, int mins) {
    return '${hours}Std ${mins}Min';
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
    return 'Gesamt: $value';
  }

  @override
  String get premiumFeatures => 'Premium-Funktionen';

  @override
  String get unlockAllFeatures => 'Alle Funktionen freischalten';

  @override
  String get noAds => 'Keine Werbung';

  @override
  String get prioritySupport => 'Priority team support';

  @override
  String get optimizePerformance => 'Optimize performance';

  @override
  String get lifetime => 'Lebenslang';

  @override
  String get buyOnce => 'Buy once, use forever';

  @override
  String get yearly => 'Jährlich';

  @override
  String get save40 => '40% sparen';

  @override
  String get terms => 'Bedingungen';

  @override
  String get restore => 'Wiederherstellen';

  @override
  String get policy => 'Richtlinie';

  @override
  String get hot => 'HEIẞ';

  @override
  String get vietnamese => 'Vietnamesisch';

  @override
  String get english => 'Englisch';

  @override
  String get languageSelection => 'Sprachauswahl';
}
