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
    return '$hoursएच';
  }

  @override
  String minutesOnly(int mins) {
    return '$minsमि';
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
  String get prioritySupport => 'प्राथमिकता टीम का समर्थन';

  @override
  String get optimizePerformance => 'प्रदर्शन का अनुकूलन करें';

  @override
  String get lifetime => 'जीवनभर';

  @override
  String get buyOnce => 'एक बार खरीदें, हमेशा के लिए उपयोग करें';

  @override
  String get yearly => 'वार्षिक';

  @override
  String get save40 => '40% बचाएं';

  @override
  String get terms => 'उपयोग की शर्तें';

  @override
  String get restore => 'पुनर्स्थापित करें';

  @override
  String get policy => 'गोपनीयता नीति';

  @override
  String get hot => 'HOT';

  @override
  String get vietnamese => 'वियतनामी';

  @override
  String get english => 'अंग्रेज़ी';

  @override
  String get languageSelection => 'भाषा चुनें';

  @override
  String get noData => 'डाटा प्राप्त नहीं हुआ';

  @override
  String get noInternet => 'कोई इंटरनेट कनेक्शन नहीं।';

  @override
  String get tryAgainConnect => 'कृपया पुनः कनेक्ट करने का प्रयास करें.';

  @override
  String get tryAgain => 'पुनः प्रयास करें';

  @override
  String get sponsored => 'प्रायोजित';

  @override
  String get stop_timer_title => 'टाइमर रोकें';

  @override
  String get stop_timer_content => 'सेटिंग बदलने से पहले कृपया टाइमर रोकें।';

  @override
  String get btn_stop => 'रोकें';

  @override
  String get btn_cancel => 'रद्द करें';

  @override
  String get version => 'संस्करण';

  @override
  String get email => 'ईमेल';

  @override
  String get share => 'साझा करें';

  @override
  String get rate => 'रेट करें';

  @override
  String get term_pw => 'शर्तें';

  @override
  String get policy_pw => 'नीति';
}
