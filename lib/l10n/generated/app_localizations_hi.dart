// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Pomodoro';

  @override
  String get timerTab => 'टाइमर';

  @override
  String get statisticsTab => 'आंकड़े';

  @override
  String get settingsTab => 'सेटअप';

  @override
  String get settings => 'सेटअप';

  @override
  String get workTime => 'फोकस';

  @override
  String get breakTime => 'ब्रेक';

  @override
  String get duration => 'अवधि';

  @override
  String get focus => 'फोकस';

  @override
  String get rest => 'आराम';

  @override
  String get alarm => 'अलार्म';

  @override
  String get volume => 'आवाज़';

  @override
  String get repeatCount => 'सत्र';

  @override
  String repeatTimes(int count) {
    return '$count सत्र';
  }

  @override
  String get repeat => 'दोहराएं';

  @override
  String minutes(int count) {
    return '$count मिनट';
  }

  @override
  String get sound => 'ध्वनि';

  @override
  String get backgroundSound => 'बैकग्राउंड साउंड';

  @override
  String get language => 'भाषा';

  @override
  String get alwaysOnScreen => 'हमेशा स्क्रीन पर';

  @override
  String get information => 'जानकारी';

  @override
  String get work => 'काम';

  @override
  String get breakLabel => 'ब्रेक';

  @override
  String get start => 'शुरू करें';

  @override
  String get continueLabel => 'जारी रखें';

  @override
  String get pause => 'रुकें';

  @override
  String get statistics => 'आंकड़े';

  @override
  String get total => 'कुल';

  @override
  String get today => 'आज';

  @override
  String get sessions => 'सत्र';

  @override
  String hoursAndMinutes(int hours, int mins) {
    return '$hoursघं $minsमि';
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
    return 'कुल: $value';
  }

  @override
  String get premiumFeatures => 'प्रीमियम विशेषताएं';

  @override
  String get unlockAllFeatures => 'सभी अनलॉक करें';

  @override
  String get noAds => 'कोई विज्ञापन नहीं';

  @override
  String get prioritySupport => 'Priority team support';

  @override
  String get optimizePerformance => 'Optimize performance';

  @override
  String get lifetime => 'जीवनभर';

  @override
  String get buyOnce => 'Buy once, use forever';

  @override
  String get yearly => 'वार्षिक';

  @override
  String get save40 => '40% बचाएं';

  @override
  String get terms => 'शर्तें';

  @override
  String get restore => 'पुनर्स्थापित करें';

  @override
  String get policy => 'नीति';

  @override
  String get hot => 'HOT';

  @override
  String get vietnamese => 'वियतनामी';

  @override
  String get english => 'अंग्रेज़ी';

  @override
  String get languageSelection => 'भाषा चुनें';
}
