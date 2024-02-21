import 'package:intl/intl.dart';

class DateTimeUtils {
  static String getYYYMMDDHHmmssFormat(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss').format((dateTime));
  }

  static String getDayMonthDayYearFormat(DateTime dateTime) {
    return DateFormat('EEE, MMM dd yyyy').format((dateTime));
  }
}
