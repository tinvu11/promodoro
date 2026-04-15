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
    return '$hours jam';
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
  String get prioritySupport => 'Dukungan tim prioritas';

  @override
  String get optimizePerformance => 'Optimalkan kinerja';

  @override
  String get lifetime => 'Selamanya';

  @override
  String get buyOnce => 'Beli sekali, gunakan selamanya';

  @override
  String get yearly => 'Tahunan';

  @override
  String get save40 => 'Hemat 40%';

  @override
  String get terms => 'Ketentuan Penggunaan';

  @override
  String get restore => 'Pulihkan';

  @override
  String get policy => 'Kebijakan Privasi';

  @override
  String get hot => 'HOT';

  @override
  String get vietnamese => 'Bahasa Vietnam';

  @override
  String get english => 'Bahasa Inggris';

  @override
  String get languageSelection => 'Pilih Bahasa';

  @override
  String get noData => 'Tidak ada data yang ditemukan';

  @override
  String get noInternet => 'Tidak ada koneksi internet.';

  @override
  String get tryAgainConnect => 'Silakan coba sambungkan lagi.';

  @override
  String get tryAgain => 'Coba lagi';

  @override
  String get sponsored => 'Disponsori';

  @override
  String get stop_timer_title => 'Hentikan timer';

  @override
  String get stop_timer_content =>
      'Silakan hentikan timer sebelum mengubah pengaturan.';

  @override
  String get btn_stop => 'Hentikan';

  @override
  String get btn_cancel => 'Batal';

  @override
  String get version => 'Versi';

  @override
  String get email => 'Email';

  @override
  String get share => 'Bagikan';

  @override
  String get rate => 'Beri Nilai';

  @override
  String get term_pw => 'Ketentuan';

  @override
  String get policy_pw => 'Kebijakan';
}
