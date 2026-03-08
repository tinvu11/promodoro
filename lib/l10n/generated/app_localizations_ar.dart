// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Pomodoro';

  @override
  String get timerTab => 'المؤقت';

  @override
  String get statisticsTab => 'الإحصائيات';

  @override
  String get settingsTab => 'الإعدادات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get workTime => 'تركيز';

  @override
  String get breakTime => 'راحة';

  @override
  String get duration => 'المدة';

  @override
  String get focus => 'تركيز';

  @override
  String get rest => 'راحة';

  @override
  String get alarm => 'المنبه';

  @override
  String get volume => 'مستوى الصوت';

  @override
  String get repeatCount => 'الجلسة';

  @override
  String repeatTimes(int count) {
    return '$count جلسة';
  }

  @override
  String get repeat => 'تكرار';

  @override
  String minutes(int count) {
    return '$count دقيقة';
  }

  @override
  String get sound => 'الصوت';

  @override
  String get backgroundSound => 'صوت الخلفية';

  @override
  String get language => 'اللغة';

  @override
  String get alwaysOnScreen => 'الشاشة تعمل دائماً';

  @override
  String get information => 'معلومات';

  @override
  String get work => 'عمل';

  @override
  String get breakLabel => 'استراحة';

  @override
  String get start => 'ابدأ';

  @override
  String get continueLabel => 'استمرار';

  @override
  String get pause => 'إيقاف';

  @override
  String get statistics => 'الإحصائيات';

  @override
  String get total => 'المجموع';

  @override
  String get today => 'اليوم';

  @override
  String get sessions => 'جلسات';

  @override
  String hoursAndMinutes(int hours, int mins) {
    return '$hours س $mins د';
  }

  @override
  String hoursOnly(int hours) {
    return '$hours ح';
  }

  @override
  String minutesOnly(int mins) {
    return '$mins م';
  }

  @override
  String totalLabel(String value) {
    return 'الإجمالي: $value';
  }

  @override
  String get premiumFeatures => 'ميزات بريميوم';

  @override
  String get unlockAllFeatures => 'فتح كل الميزات';

  @override
  String get noAds => 'بدون إعلانات';

  @override
  String get prioritySupport => 'دعم الفريق ذو الأولوية';

  @override
  String get optimizePerformance => 'تحسين الأداء';

  @override
  String get lifetime => 'مدى الحياة';

  @override
  String get buyOnce => 'شراء مرة واحدة، واستخدام إلى الأبد';

  @override
  String get yearly => 'سنوي';

  @override
  String get save40 => 'توفير 40%';

  @override
  String get terms => 'شروط الاستخدام';

  @override
  String get restore => 'استعادة';

  @override
  String get policy => 'سياسة الخصوصية';

  @override
  String get hot => 'نشط';

  @override
  String get vietnamese => 'الفيتنامية';

  @override
  String get english => 'الإنجليزية';

  @override
  String get languageSelection => 'اختر اللغة';

  @override
  String get noData => 'لم يتم العثور على بيانات';

  @override
  String get noInternet => 'لا يوجد اتصال بالإنترنت.';

  @override
  String get tryAgainConnect => 'الرجاء محاولة الاتصال مرة أخرى.';

  @override
  String get tryAgain => 'حاول ثانية';

  @override
  String get sponsored => 'برعاية';

  @override
  String get stop_timer_title => 'إيقاف المؤقت';

  @override
  String get stop_timer_content => 'يرجى إيقاف المؤقت قبل تغيير الإعدادات.';

  @override
  String get btn_stop => 'إيقاف';

  @override
  String get btn_cancel => 'إلغاء';

  @override
  String get version => 'الإصدار';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get share => 'مشاركة';

  @override
  String get rate => 'تقييم';
}
