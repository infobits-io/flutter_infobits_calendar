import 'package:flutter/material.dart';
import '../extensions/date_time.dart';

import 'calendar_event.dart';
import 'calendar_style.dart';
import 'calendar_text.dart';
import 'responsive_layout.dart';

class CalendarTitle<T extends CalendarEvent> extends StatelessWidget {
  final void Function()? onPressed;
  final DateTime startShowingDate;
  final DateTime endShowingDate;

  const CalendarTitle({
    Key? key,
    this.onPressed,
    required this.startShowingDate,
    required this.endShowingDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var calendarText = CalendarText.of(context);
    var calendarStyle = CalendarStyle.of<T>(context);

    return SizedBox(
      height: 50,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment:
            ScreenSizes.isMobile(context) || ScreenSizes.isTablet(context)
                ? Alignment.center
                : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(10),
          height: 50,
          child: GestureDetector(
            onTap: onPressed,
            child: Container(
              padding: ScreenSizes.isMobile(context)
                  ? null
                  : const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Row(
                mainAxisAlignment: ScreenSizes.isMobile(context)
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  Text(
                    startShowingDate.isSameDate(endShowingDate)
                        ? calendarText.prettyWeekdayString(startShowingDate)
                        : "${calendarText.prettyWeekdayString(startShowingDate)} - ${calendarText.prettyWeekdayString(endShowingDate)}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
                    decoration: BoxDecoration(
                        color: calendarStyle.secondaryBackgroundColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Text(
                        "${calendarText.week} ${startShowingDate.weekNumber()}"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
