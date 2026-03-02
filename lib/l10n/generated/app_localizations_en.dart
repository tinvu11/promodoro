// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Promodoro';

  @override
  String get timerTab => 'Timer';

  @override
  String get statisticsTab => 'Statistics';

  @override
  String get settingsTab => 'Settings';

  @override
  String get settings => 'Settings';

  @override
  String get workTime => 'Focus';

  @override
  String get breakTime => 'Rest';

  @override
  String get duration => 'Duration';

  @override
  String get focus => 'Focus';

  @override
  String get rest => 'Rest';

  @override
  String get alarm => 'Alarm';

  @override
  String get volume => 'Volume';

  @override
  String get repeatCount => 'Session';

  @override
  String repeatTimes(int count) {
    return '$count ses';
  }

  @override
  String get repeat => 'Repeat';

  @override
  String minutes(int count) {
    return '$count min';
  }

  @override
  String get sound => 'Sound';

  @override
  String get backgroundSound => 'Background sound';

  @override
  String get language => 'Language';

  @override
  String get alwaysOnScreen => 'Always on screen';

  @override
  String get information => 'Information';

  @override
  String get work => 'Work';

  @override
  String get breakLabel => 'Break';

  @override
  String get start => 'Start';

  @override
  String get continueLabel => 'Continue';

  @override
  String get pause => 'Pause';

  @override
  String get statistics => 'Statistics';

  @override
  String get total => 'Total';

  @override
  String get today => 'Today';

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
    return '${mins}m';
  }

  @override
  String totalLabel(String value) {
    return 'Total: $value';
  }

  @override
  String get premiumFeatures => 'Premium Features';

  @override
  String get unlockAllFeatures => 'Unlock all features';

  @override
  String get noAds => 'No ads at all';

  @override
  String get prioritySupport => 'Priority team support';

  @override
  String get optimizePerformance => 'Optimize performance';

  @override
  String get lifetime => 'Lifetime';

  @override
  String get buyOnce => 'Buy once, use forever';

  @override
  String get yearly => 'Yearly';

  @override
  String get save40 => 'Save 40%';

  @override
  String get terms => 'Terms';

  @override
  String get restore => 'Restore';

  @override
  String get policy => 'Policy';

  @override
  String get hot => 'HOT';

  @override
  String get vietnamese => 'Vietnamese';

  @override
  String get english => 'English';

  @override
  String get languageSelection => 'Language';
}
