import 'package:flutter/material.dart';

import 'calendar_nav_day.dart';

class CalendarNav extends StatelessWidget {
  final bool offsetTimestamp;
  final DateTime startShowingDate;
  final DateTime endShowingDate;

  final List<CalendarNavDay>? days;

  const CalendarNav({
    super.key,
    this.offsetTimestamp = false,
    required this.startShowingDate,
    required this.endShowingDate,
    this.days,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: (offsetTimestamp ? 45 : 0)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: days ??
                  [
                    for (var i = 1; i < 8; i++)
                      CalendarNavDay(
                        date: startShowingDate.subtract(
                            Duration(days: startShowingDate.weekday - i)),
                        isSelectedDay: false,
                      ),
                  ],
            ),
          ),
        ],
      ),
    );
  }
}
