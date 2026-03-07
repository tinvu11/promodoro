// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Pomodoro';

  @override
  String get timerTab => '计时器';

  @override
  String get statisticsTab => '统计';

  @override
  String get settingsTab => '设置';

  @override
  String get settings => '设置';

  @override
  String get workTime => '专注';

  @override
  String get breakTime => '休息';

  @override
  String get duration => '时长';

  @override
  String get focus => '专注';

  @override
  String get rest => '休息';

  @override
  String get alarm => '闹钟';

  @override
  String get volume => '音量';

  @override
  String get repeatCount => '回合';

  @override
  String repeatTimes(int count) {
    return '$count 次';
  }

  @override
  String get repeat => '重复';

  @override
  String minutes(int count) {
    return '$count 分钟';
  }

  @override
  String get sound => '声音';

  @override
  String get backgroundSound => '背景音';

  @override
  String get language => '语言';

  @override
  String get alwaysOnScreen => '屏幕常亮';

  @override
  String get information => '信息';

  @override
  String get work => '工作';

  @override
  String get breakLabel => '休息';

  @override
  String get start => '开始';

  @override
  String get continueLabel => '继续';

  @override
  String get pause => '暂停';

  @override
  String get statistics => '统计';

  @override
  String get total => '累计';

  @override
  String get today => '今日';

  @override
  String get sessions => '次';

  @override
  String hoursAndMinutes(int hours, int mins) {
    return '$hours小时 $mins分';
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
    return '总计: $value';
  }

  @override
  String get premiumFeatures => '高级功能';

  @override
  String get unlockAllFeatures => '解锁全部功能';

  @override
  String get noAds => '无广告';

  @override
  String get prioritySupport => 'Priority team support';

  @override
  String get optimizePerformance => 'Optimize performance';

  @override
  String get lifetime => '永久';

  @override
  String get buyOnce => 'Buy once, use forever';

  @override
  String get yearly => '年度制';

  @override
  String get save40 => '节省 40%';

  @override
  String get terms => '条款';

  @override
  String get restore => '恢复购买';

  @override
  String get policy => '政策';

  @override
  String get hot => '热门';

  @override
  String get vietnamese => '越南语';

  @override
  String get english => '英语';

  @override
  String get languageSelection => '选择语言';
}
