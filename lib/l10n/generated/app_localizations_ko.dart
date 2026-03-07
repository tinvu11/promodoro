// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Pomodoro';

  @override
  String get timerTab => '타이머';

  @override
  String get statisticsTab => '통계';

  @override
  String get settingsTab => '설정';

  @override
  String get settings => '설정';

  @override
  String get workTime => '집중';

  @override
  String get breakTime => '휴식';

  @override
  String get duration => '시간';

  @override
  String get focus => '집중';

  @override
  String get rest => '휴식';

  @override
  String get alarm => '알람';

  @override
  String get volume => '음량';

  @override
  String get repeatCount => '세션';

  @override
  String repeatTimes(int count) {
    return '$count회';
  }

  @override
  String get repeat => '반복';

  @override
  String minutes(int count) {
    return '$count분';
  }

  @override
  String get sound => '소리';

  @override
  String get backgroundSound => '배경음';

  @override
  String get language => '언어';

  @override
  String get alwaysOnScreen => '화면 켜짐 유지';

  @override
  String get information => '정보';

  @override
  String get work => '집중';

  @override
  String get breakLabel => '휴식';

  @override
  String get start => '시작';

  @override
  String get continueLabel => '계속하기';

  @override
  String get pause => '일시정지';

  @override
  String get statistics => '통계';

  @override
  String get total => '합계';

  @override
  String get today => '오늘';

  @override
  String get sessions => '세션';

  @override
  String hoursAndMinutes(int hours, int mins) {
    return '$hours시간 $mins분';
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
    return '총합: $value';
  }

  @override
  String get premiumFeatures => '프리미엄 기능';

  @override
  String get unlockAllFeatures => '모든 기능 잠금 해제';

  @override
  String get noAds => '광고 제거';

  @override
  String get prioritySupport => 'Priority team support';

  @override
  String get optimizePerformance => 'Optimize performance';

  @override
  String get lifetime => '평생 소장';

  @override
  String get buyOnce => 'Buy once, use forever';

  @override
  String get yearly => '연간 구독';

  @override
  String get save40 => '40% 절약';

  @override
  String get terms => '약관';

  @override
  String get restore => '구매 복원';

  @override
  String get policy => '정책';

  @override
  String get hot => '인기';

  @override
  String get vietnamese => '베트남어';

  @override
  String get english => '영어';

  @override
  String get languageSelection => '언어 선택';
}
