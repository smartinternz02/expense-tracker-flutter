import 'package:intl/intl.dart';

extension DateTimeUtils on DateTime {
  // static String getYYYMMDDHHmmssFormat(DateTime dateTime) {
  //   return DateFormat('yyyy-MM-dd hh:mm:ss').format((dateTime));
  // }

  String getYYYMMDDHHmmssFormat() {
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(this);
  }

  static String getDayMonthDayYearFormat(DateTime dateTime) {
    return DateFormat('EEE, MMM dd yyyy').format((dateTime));
  }
}
