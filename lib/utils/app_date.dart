import 'package:intl/intl.dart';

class AppDate {
  static DateFormat get idFormat => DateFormat('yyyy-MM-dd');

  static DateFormat get dayFormat => DateFormat('dd');

  static DateFormat get monthYearFormat => DateFormat('MM/yyyy');

  static String formatId(DateTime date) => idFormat.format(date);
}
