import 'package:intl/intl.dart';

class AppDate {
  // Định dạng chuẩn để làm Key lưu Hive
  static DateFormat get idFormat => DateFormat('yyyy-MM-dd');

  // Định dạng hiển thị trên biểu đồ hoặc UI
  static DateFormat get dayFormat => DateFormat('dd');

  static DateFormat get monthYearFormat => DateFormat('MM/yyyy');

  static String formatId(DateTime date) => idFormat.format(date);
}
