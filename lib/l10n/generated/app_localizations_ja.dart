// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Pomodoro';

  @override
  String get timerTab => 'タイマー';

  @override
  String get statisticsTab => '統計';

  @override
  String get settingsTab => '設定';

  @override
  String get settings => '設定';

  @override
  String get workTime => '集中';

  @override
  String get breakTime => '休憩';

  @override
  String get duration => '時間';

  @override
  String get focus => '集中';

  @override
  String get rest => '休憩';

  @override
  String get alarm => 'アラーム';

  @override
  String get volume => '音量';

  @override
  String get repeatCount => 'セッション';

  @override
  String repeatTimes(int count) {
    return '$count 回';
  }

  @override
  String get repeat => '繰り返し';

  @override
  String minutes(int count) {
    return '$count 分';
  }

  @override
  String get sound => '音';

  @override
  String get backgroundSound => '環境音';

  @override
  String get language => '言語';

  @override
  String get alwaysOnScreen => '常時表示';

  @override
  String get information => '情報';

  @override
  String get work => '仕事';

  @override
  String get breakLabel => '休憩';

  @override
  String get start => '開始';

  @override
  String get continueLabel => '再開';

  @override
  String get pause => '一時停止';

  @override
  String get statistics => '統計';

  @override
  String get total => '合計';

  @override
  String get today => '今日';

  @override
  String get sessions => 'セッション';

  @override
  String hoursAndMinutes(int hours, int mins) {
    return '$hours時間 $mins分';
  }

  @override
  String hoursOnly(int hours) {
    return '$hours時間';
  }

  @override
  String minutesOnly(int mins) {
    return '$mins分';
  }

  @override
  String totalLabel(String value) {
    return '合計: $value';
  }

  @override
  String get premiumFeatures => 'プレミアム機能';

  @override
  String get unlockAllFeatures => '全機能解放';

  @override
  String get noAds => '広告なし';

  @override
  String get prioritySupport => '優先チームサポート';

  @override
  String get optimizePerformance => 'パフォーマンスを最適化する';

  @override
  String get lifetime => '買い切り';

  @override
  String get buyOnce => '一度購入すれば永久に使用可能';

  @override
  String get yearly => '年額';

  @override
  String get save40 => '40%お得';

  @override
  String get terms => '利用規約';

  @override
  String get restore => '復元';

  @override
  String get policy => 'プライバシーポリシー';

  @override
  String get hot => '人気';

  @override
  String get vietnamese => 'ベトナム語';

  @override
  String get english => '英語';

  @override
  String get languageSelection => '言語選択';

  @override
  String get noData => 'データが見つかりませんでした';

  @override
  String get noInternet => 'インターネット接続がありません。';

  @override
  String get tryAgainConnect => 'もう一度接続してみてください。';

  @override
  String get tryAgain => 'もう一度やり直してください';

  @override
  String get sponsored => 'スポンサー';

  @override
  String get stop_timer_title => 'タイマーを停止';

  @override
  String get stop_timer_content => '設定を変更する前にタイマーを停止してください。';

  @override
  String get btn_stop => '停止';

  @override
  String get btn_cancel => 'キャンセル';

  @override
  String get version => 'バージョン';

  @override
  String get email => 'メール';

  @override
  String get share => '共有';

  @override
  String get rate => '評価';

  @override
  String get term_pw => '規約';

  @override
  String get policy_pw => 'ポリシー';
}
