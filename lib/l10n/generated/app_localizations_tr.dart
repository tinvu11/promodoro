// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Pomodoro';

  @override
  String get timerTab => 'Zamanlayıcı';

  @override
  String get statisticsTab => 'İstatistikler';

  @override
  String get settingsTab => 'Ayarlar';

  @override
  String get settings => 'Ayarlar';

  @override
  String get workTime => 'Odak';

  @override
  String get breakTime => 'Mola';

  @override
  String get duration => 'Süre';

  @override
  String get focus => 'Odak';

  @override
  String get rest => 'Dinlenme';

  @override
  String get alarm => 'Alarm';

  @override
  String get volume => 'Ses';

  @override
  String get repeatCount => 'Oturum';

  @override
  String repeatTimes(int count) {
    return '$count oturum';
  }

  @override
  String get repeat => 'Tekrar';

  @override
  String minutes(int count) {
    return '$count dk';
  }

  @override
  String get sound => 'Ses';

  @override
  String get backgroundSound => 'Arka plan sesi';

  @override
  String get language => 'Dil';

  @override
  String get alwaysOnScreen => 'Ekran hep açık';

  @override
  String get information => 'Bilgi';

  @override
  String get work => 'Çalışma';

  @override
  String get breakLabel => 'Mola';

  @override
  String get start => 'Başlat';

  @override
  String get continueLabel => 'Devam et';

  @override
  String get pause => 'Duraklat';

  @override
  String get statistics => 'İstatistikler';

  @override
  String get total => 'Toplam';

  @override
  String get today => 'Bugün';

  @override
  String get sessions => 'oturum';

  @override
  String hoursAndMinutes(int hours, int mins) {
    return '${hours}sa ${mins}dk';
  }

  @override
  String hoursOnly(int hours) {
    return '${hours}sa';
  }

  @override
  String minutesOnly(int mins) {
    return '$mins dk';
  }

  @override
  String totalLabel(String value) {
    return 'Toplam: $value';
  }

  @override
  String get premiumFeatures => 'Premium Özellikler';

  @override
  String get unlockAllFeatures => 'Tümünü aç';

  @override
  String get noAds => 'Reklamsız';

  @override
  String get prioritySupport => 'Öncelikli ekip desteği';

  @override
  String get optimizePerformance => 'Performansı optimize edin';

  @override
  String get lifetime => 'Ömür boyu';

  @override
  String get buyOnce => 'Bir kez satın alın, sonsuza kadar kullanın';

  @override
  String get yearly => 'Yıllık';

  @override
  String get save40 => '%40 Tasarruf';

  @override
  String get terms => 'Kullanım Şartları';

  @override
  String get restore => 'Geri Yükle';

  @override
  String get policy => 'Gizlilik Politikası';

  @override
  String get hot => 'SICAK';

  @override
  String get vietnamese => 'Vietnamca';

  @override
  String get english => 'İngilizce';

  @override
  String get languageSelection => 'Dil Seçin';

  @override
  String get noData => 'Veri bulunamadı';

  @override
  String get noInternet => 'İnternet bağlantısı yok.';

  @override
  String get tryAgainConnect => 'Lütfen tekrar bağlanmayı deneyin.';

  @override
  String get tryAgain => 'Tekrar deneyin';

  @override
  String get sponsored => 'Sponsorlu';

  @override
  String get stop_timer_title => 'Zamanlayıcıyı durdur';

  @override
  String get stop_timer_content =>
      'Ayarları değiştirmeden önce lütfen zamanlayıcıyı durdurun.';

  @override
  String get btn_stop => 'Durdur';

  @override
  String get btn_cancel => 'İptal';

  @override
  String get version => 'Sürüm';

  @override
  String get email => 'E-posta';

  @override
  String get share => 'Paylaş';

  @override
  String get rate => 'Değerlendir';

  @override
  String get term_pw => 'Şartlar';

  @override
  String get policy_pw => 'Politika';
}
