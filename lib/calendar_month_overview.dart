import 'package:flutter/material.dart';
import '../extensions/date_time.dart';
import 'calendar_event.dart';
import 'calendar_style.dart';
import 'calendar_text.dart';
import 'on_hover.dart';

enum CalendarMonthOverviewDaySelect { middle, left, right, only, not }

class CalendarMonthOverview<T extends CalendarEvent> extends StatefulWidget {
  final DateTime startShowingDate;
  final DateTime endShowingDate;
  final void Function(DateTime dayDate) onDayPressed;

  const CalendarMonthOverview({
    super.key,
    required this.onDayPressed,
    required this.startShowingDate,
    required this.endShowingDate,
  });

  @override
  State<CalendarMonthOverview<T>> createState() =>
      CalendarMonthOverviewState<T>();
}

class CalendarMonthOverviewState<T extends CalendarEvent>
    extends State<CalendarMonthOverview<T>> {
  int currentYear = DateTime.now().year;
  int currentMonth = DateTime.now().month;
  DateTime? lastCurrentDate;

  @override
  void initState() {
    if (!widget.startShowingDate
        .isSameMonth(DateTime(currentYear, currentMonth))) {
      currentYear = widget.startShowingDate.year;
      currentMonth = widget.startShowingDate.month;
    }
    super.initState();
  }

  void prevMonth() {
    setState(() {
      currentMonth--;
      if (currentMonth < 1) {
        currentYear--;
        currentMonth = 12;
      }
    });
  }

  void nextMonth() {
    setState(() {
      currentMonth++;
      if (currentMonth > 12) {
        currentYear++;
        currentMonth = 1;
      }
    });
  }

  void checkDaySelected(DateTime startDate, DateTime endDate) {
    var middleDate = startDate;
    if (!startDate.isSameDate(endDate)) {
      middleDate = startDate.add(
          Duration(days: (endDate.difference(startDate).inDays / 2).floor()));
    }
    if (!middleDate.isSameMonth(DateTime(currentYear, currentMonth))) {
      currentYear = middleDate.year;
      currentMonth = middleDate.month;
      setState(() {});
    }
  }

  bool dateHasEvent(DateTime date) {
    return false;
  }

  CalendarMonthOverviewDaySelect isDaySelected(DateTime day) {
    if (day.isSameDate(widget.startShowingDate) &&
        day.isSameDate(widget.endShowingDate)) {
      return CalendarMonthOverviewDaySelect.only;
    } else if (day.isSameDate(widget.startShowingDate)) {
      return CalendarMonthOverviewDaySelect.left;
    } else if (day.isSameDate(widget.endShowingDate)) {
      return CalendarMonthOverviewDaySelect.right;
    } else if (day.isAfter(widget.startShowingDate) &&
        day.isBefore(widget.endShowingDate)) {
      return CalendarMonthOverviewDaySelect.middle;
    }

    return CalendarMonthOverviewDaySelect.not;
  }

  BorderRadius? getDayBorderRadius(DateTime day) {
    switch (isDaySelected(day)) {
      case CalendarMonthOverviewDaySelect.only:
        return const BorderRadius.all(Radius.circular(999));
      case CalendarMonthOverviewDaySelect.middle:
        return null;
      case CalendarMonthOverviewDaySelect.left:
        return const BorderRadius.only(
            topLeft: Radius.circular(999), bottomLeft: Radius.circular(999));
      case CalendarMonthOverviewDaySelect.right:
        return const BorderRadius.only(
            topRight: Radius.circular(999), bottomRight: Radius.circular(999));
      case CalendarMonthOverviewDaySelect.not:
        return null;

      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var calendarText = CalendarText.of(context);
    var calendarStyle = CalendarStyle.of<T>(context);

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "${calendarText.months.month(DateTime(currentYear, currentMonth))} $currentYear",
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
                GestureDetector(
                  onTap: prevMonth,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                        color: calendarStyle.primaryBackgroundColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 10),
                        child: calendarStyle.icons.overviewPrevIcon),
                  ),
                ),
                GestureDetector(
                  onTap: nextMonth,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                        color: calendarStyle.primaryBackgroundColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 10),
                        child: calendarStyle.icons.overviewNextIcon),
                  ),
                )
              ],
            ),
          ),
          Table(
            children: [
              TableRow(children: [
                for (var weekdayNum = 0; weekdayNum <= 7; weekdayNum++)
                  AspectRatio(
                      aspectRatio: 1,
                      child: weekdayNum == 0
                          ? Container()
                          : Center(
                              child: Text(calendarText.weekdays
                                  .byNum(weekdayNum)
                                  .toString()[0]),
                            ))
              ]),
              for (var weekNum = 0; weekNum < 6; weekNum++)
                TableRow(children: [
                  for (var weekdayNum = 0; weekdayNum <= 7; weekdayNum++)
                    OnHover(builder: (hover) {
                      var weekDate = DateTime(currentYear, currentMonth)
                          .add(Duration(days: 7 * weekNum));
                      var dayDate = weekDate.subtract(
                          Duration(days: weekDate.weekday - weekdayNum));
                      return AspectRatio(
                          aspectRatio: 1,
                          child: weekdayNum == 0
                              ? Container(
                                  decoration: BoxDecoration(
                                    color:
                                        calendarStyle.secondaryBackgroundColor,
                                    borderRadius: weekNum == 0
                                        ? const BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            topLeft: Radius.circular(10))
                                        : (weekNum == 5
                                            ? const BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10))
                                            : null),
                                  ),
                                  child: Center(
                                    child:
                                        Text(weekDate.weekNumber().toString()),
                                  ),
                                )
                              : AnimatedContainer(
                                  padding: const EdgeInsets.all(1),
                                  duration: const Duration(milliseconds: 100),
                                  decoration: BoxDecoration(
                                    borderRadius: getDayBorderRadius(dayDate),
                                    color: isDaySelected(dayDate) !=
                                            CalendarMonthOverviewDaySelect.not
                                        ? calendarStyle.secondaryBackgroundColor
                                        : null,
                                  ),
                                  child: GestureDetector(
                                    onTap: () => widget.onDayPressed(dayDate),
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 100),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: DateTime.now()
                                                    .isSameDate(dayDate)
                                                ? calendarStyle.primaryColor
                                                : (hover
                                                    ? calendarStyle
                                                        .secondaryBackgroundColor
                                                    : null)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 3,
                                              height: 3,
                                              color: const Color(0x00ffffff),
                                            ),
                                            Text(
                                              "${dayDate.day}",
                                              style: TextStyle(
                                                  color: DateTime.now()
                                                          .isSameDate(dayDate)
                                                      ? calendarStyle
                                                          .primaryColorContrast
                                                      : (dayDate.isSameMonth(
                                                              DateTime(
                                                                  currentYear,
                                                                  currentMonth))
                                                          ? null
                                                          : calendarStyle
                                                              .secondaryTextColor)),
                                            ),
                                            Container(
                                              width: 3,
                                              height: 3,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: dateHasEvent(dayDate)
                                                    ? (DateTime.now()
                                                            .isSameDate(dayDate)
                                                        ? calendarStyle
                                                            .primaryColorContrast
                                                        : (dayDate.isSameMonth(
                                                                DateTime(
                                                                    currentYear,
                                                                    currentMonth))
                                                            ? calendarStyle
                                                                .primaryTextColor
                                                            : calendarStyle
                                                                .secondaryTextColor))
                                                    : const Color(0x00ffffff),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ));
                    })
                ])
            ],
          ),
        ],
      ),
    );
  }
}
