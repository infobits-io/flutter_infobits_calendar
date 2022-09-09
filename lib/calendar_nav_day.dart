import 'package:flutter/material.dart';
import '../extensions/date_time.dart';
import 'calendar_style.dart';
import 'calendar_text.dart';

class CalendarNavDay extends StatelessWidget {
  final bool isSelectedDay;
  final DateTime date;

  const CalendarNavDay({
    Key? key,
    required this.date,
    required this.isSelectedDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: () => debugPrint("nav day clicked"),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: SizedBox(
          width: double.infinity,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  CalendarText.of(context).weekdays.weekdayShort(date),
                  style: date.isSameDate(DateTime.now())
                      ? TextStyle(color: CalendarStyle.of(context).primaryColor)
                      : null,
                ),
                SizedBox(
                  width: 30,
                  child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: date.isSameDate(DateTime.now())
                                ? CalendarStyle.of(context).primaryColor
                                : (isSelectedDay
                                    ? CalendarStyle.of(context)
                                        .secondaryBackgroundColor
                                    : null)),
                        child: Center(
                          child: Text(
                            date.day.toString(),
                            style: date.isSameDate(DateTime.now())
                                ? TextStyle(
                                    color: CalendarStyle.of(context)
                                        .primaryBackgroundColor)
                                : null,
                          ),
                        ),
                      )),
                )
              ]),
        ),
      ),
    ));
  }
}
