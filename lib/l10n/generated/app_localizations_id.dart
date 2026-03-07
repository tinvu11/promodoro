// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Pomodoro';

  @override
  String get timerTab => 'Timer';

  @override
  String get statisticsTab => 'Statistik';

  @override
  String get settingsTab => 'Pengaturan';

  @override
  String get settings => 'Pengaturan';

  @override
  String get workTime => 'Fokus';

  @override
  String get breakTime => 'Istirahat';

  @override
  String get duration => 'Durasi';

  @override
  String get focus => 'Fokus';

  @override
  String get rest => 'Istirahat';

  @override
  String get alarm => 'Alarm';

  @override
  String get volume => 'Volume';

  @override
  String get repeatCount => 'Sesi';

  @override
  String repeatTimes(int count) {
    return '$count sesi';
  }

  @override
  String get repeat => 'Ulangi';

  @override
  String minutes(int count) {
    return '$count menit';
  }

  @override
  String get sound => 'Suara';

  @override
  String get backgroundSound => 'Suara latar';

  @override
  String get language => 'Bahasa';

  @override
  String get alwaysOnScreen => 'Selalu aktif';

  @override
  String get information => 'Informasi';

  @override
  String get work => 'Kerja';

  @override
  String get breakLabel => 'Istirahat';

  @override
  String get start => 'Mulai';

  @override
  String get continueLabel => 'Lanjut';

  @override
  String get pause => 'Jeda';

  @override
  String get statistics => 'Statistik';

  @override
  String get total => 'Total';

  @override
  String get today => 'Hari ini';

  @override
  String get sessions => 'sesi';

  @override
  String hoursAndMinutes(int hours, int mins) {
    return '${hours}j ${mins}m';
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
  String get premiumFeatures => 'Fitur Premium';

  @override
  String get unlockAllFeatures => 'Buka semua fitur';

  @override
  String get noAds => 'Tanpa iklan';

  @override
  String get prioritySupport => 'Priority team support';

  @override
  String get optimizePerformance => 'Optimize performance';

  @override
  String get lifetime => 'Selamanya';

  @override
  String get buyOnce => 'Buy once, use forever';

  @override
  String get yearly => 'Tahunan';

  @override
  String get save40 => 'Hemat 40%';

  @override
  String get terms => 'Ketentuan';

  @override
  String get restore => 'Pulihkan';

  @override
  String get policy => 'Kebijakan';

  @override
  String get hot => 'HOT';

  @override
  String get vietnamese => 'Bahasa Vietnam';

  @override
  String get english => 'Bahasa Inggris';

  @override
  String get languageSelection => 'Pilih Bahasa';
}
