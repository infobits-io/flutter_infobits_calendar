import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  static int numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  bool isSameDate(DateTime? other) {
    if (other == null) return false;
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameWeek(DateTime other) {
    return weekNumber() == other.weekNumber();
  }

  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  /// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
  int weekNumber() {
    int dayOfYear = int.parse(DateFormat("D").format(this));
    int woy = ((dayOfYear - weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = numOfWeeks(year - 1);
    } else if (woy > numOfWeeks(year)) {
      woy = 1;
    }
    return woy;
  }

  String get timeString =>
      "${hour.toString().padLeft(2, "0")}:${minute.toString().padLeft(2, "0")}";
}
