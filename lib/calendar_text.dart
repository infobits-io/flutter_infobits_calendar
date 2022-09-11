import 'package:flutter/material.dart';
import '../extensions/date_time.dart';

class CalendarText {
  final String createText;
  final String clickClose;
  final String overview;
  final String extra;
  final String errorMessage;

  final String week;
  final CalendarTextWeekDays weekdays;
  final CalendarTextMonths months;

  const CalendarText({
    this.createText = "Create",
    this.week = "Week",
    this.clickClose = "Click to Close",
    this.overview = "Overview",
    this.extra = "Other",
    this.errorMessage = "an error occurred",
    this.weekdays = const CalendarTextWeekDays(),
    this.months = const CalendarTextMonths(),
  });

  String prettyDateString(DateTime date) {
    if (date.year == DateTime.now().year) {
      return "${date.day}. ${months.monthShort(date)}, ${date.timeString}";
    } else {
      return "${date.day}. ${months.monthShort(date)} ${date.year}, ${date.timeString}";
    }
  }

  String prettyWeekdayString(DateTime date) {
    if (date.year == DateTime.now().year) {
      return "${weekdays.weekday(date)}, ${date.day}. ${months.monthShort(date)}";
    } else {
      return "${weekdays.weekday(date)}, ${date.day}. ${months.monthShort(date)} ${date.year}";
    }
  }

  static CalendarText of(BuildContext context) {
    final inheritedOptions =
        context.dependOnInheritedWidgetOfExactType<InheritedCalendarText>();
    return inheritedOptions?.text ?? const CalendarText();
  }
}

class CalendarTextWeekDays {
  final String monday;
  final String tuesday;
  final String wednesday;
  final String thursday;
  final String friday;
  final String saturday;
  final String sunday;

  const CalendarTextWeekDays({
    this.monday = "Monday",
    this.tuesday = "Tuesday",
    this.wednesday = "Wednesday",
    this.thursday = "Thursday",
    this.friday = "Friday",
    this.saturday = "Saturday",
    this.sunday = "Sunday",
  });

  String byNum(int index) {
    switch (index) {
      case 1:
        return monday;
      case 2:
        return tuesday;
      case 3:
        return wednesday;
      case 4:
        return thursday;
      case 5:
        return friday;
      case 6:
        return saturday;
      case 7:
        return sunday;
      default:
        return "Unknown";
    }
  }

  String weekday(DateTime date) {
    return byNum(date.weekday);
  }

  String weekdayShort(DateTime date) {
    return byNum(date.weekday).substring(0, 3);
  }
}

class CalendarTextMonths {
  final String january;
  final String february;
  final String march;
  final String april;
  final String may;
  final String june;
  final String july;
  final String august;
  final String september;
  final String october;
  final String november;
  final String december;

  const CalendarTextMonths({
    this.january = "January",
    this.february = "February",
    this.march = "March",
    this.april = "April",
    this.may = "May",
    this.june = "June",
    this.july = "July",
    this.august = "August",
    this.september = "September",
    this.october = "October",
    this.november = "November",
    this.december = "December",
  });

  String byNum(int index) {
    switch (index) {
      case 1:
        return january;
      case 2:
        return february;
      case 3:
        return march;
      case 4:
        return april;
      case 5:
        return may;
      case 6:
        return june;
      case 7:
        return july;
      case 8:
        return august;
      case 9:
        return september;
      case 10:
        return october;
      case 11:
        return november;
      case 12:
        return december;
      default:
        return "Unknown";
    }
  }

  String month(DateTime date) {
    return byNum(date.month);
  }

  String monthShort(DateTime date) {
    return byNum(date.month).substring(0, 3);
  }
}

class InheritedCalendarText extends InheritedWidget {
  final CalendarText text;

  const InheritedCalendarText({
    super.key,
    required this.text,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedCalendarText oldWidget) {
    return oldWidget.text != text;
  }
}
