// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Promodoro';

  @override
  String get timerTab => 'Hẹn giờ';

  @override
  String get statisticsTab => 'Thống kê';

  @override
  String get settingsTab => 'Cài đặt';

  @override
  String get settings => 'Cài đặt';

  @override
  String get workTime => 'Tập trung';

  @override
  String get breakTime => 'Thư giãn';

  @override
  String get duration => 'Thời lượng';

  @override
  String get focus => 'Tập trung';

  @override
  String get rest => 'Thư giãn';

  @override
  String get alarm => 'Âm báo';

  @override
  String get volume => 'Âm lượng';

  @override
  String get repeatCount => 'Vòng lặp';

  @override
  String repeatTimes(int count) {
    return '$count lần';
  }

  @override
  String get repeat => 'Lần lặp';

  @override
  String minutes(int count) {
    return '$count phút';
  }

  @override
  String get sound => 'Âm thanh';

  @override
  String get backgroundSound => 'Âm thanh nền';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get alwaysOnScreen => 'Luôn bật màn hình';

  @override
  String get information => 'Thông tin';

  @override
  String get work => 'Tập trung';

  @override
  String get breakLabel => 'Nghỉ ngơi';

  @override
  String get start => 'Bắt đầu';

  @override
  String get continueLabel => 'Tiếp tục';

  @override
  String get pause => 'Tạm dừng';

  @override
  String get statistics => 'Thống kê';

  @override
  String get total => 'Tổng';

  @override
  String get today => 'Hôm nay';

  @override
  String get sessions => 'phiên';

  @override
  String hoursAndMinutes(int hours, int mins) {
    return '$hours giờ $mins phút';
  }

  @override
  String hoursOnly(int hours) {
    return '$hours giờ';
  }

  @override
  String minutesOnly(int mins) {
    return '$mins phút';
  }

  @override
  String totalLabel(String value) {
    return 'Tổng: $value';
  }

  @override
  String get premiumFeatures => 'Tính năng Premium';

  @override
  String get unlockAllFeatures => 'Mở khoá toàn bộ tính năng';

  @override
  String get noAds => 'Không có bất kỳ quảng cáo';

  @override
  String get prioritySupport => 'Ưu tiên hỗ trợ từ nhóm';

  @override
  String get optimizePerformance => 'Tối ưu hoá hiệu năng';

  @override
  String get lifetime => 'Vĩnh viễn';

  @override
  String get buyOnce => 'Mua 1 lần, dùng mãi mãi';

  @override
  String get yearly => 'Hàng năm';

  @override
  String get save40 => 'Tiết kiệm 40%';

  @override
  String get terms => 'Điều khoản';

  @override
  String get restore => 'Khôi phục';

  @override
  String get policy => 'Chính sách';

  @override
  String get hot => 'HOT';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'Tiếng Anh';

  @override
  String get languageSelection => 'Ngôn ngữ';
}
