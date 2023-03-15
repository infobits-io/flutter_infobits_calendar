import 'package:flutter/material.dart';

import '../calendar_event.dart';
import '../calendar_event_box.dart';
import '../calendar_event_provider.dart';
import '../calendar_style.dart';

abstract class CalendarView<T extends CalendarEvent> extends StatefulWidget {
  final CalendarEventProvider<T> eventProvider;
  final void Function(DateTime startDate, DateTime endDate,
      {bool updateAll, bool updateView}) onDateIntervalChange;
  final DateTime initialStartShowingDate;
  final DateTime initialEndShowingDate;

  const CalendarView({
    super.key,
    required this.eventProvider,
    required this.onDateIntervalChange,
    required this.initialStartShowingDate,
    required this.initialEndShowingDate,
  });

  @override
  CalendarViewState<T, CalendarView<T>> createState();
}

abstract class CalendarViewState<T extends CalendarEvent,
    S extends CalendarView<T>> extends State<S> {
  DateTime startShowingDate;
  DateTime endShowingDate;

  CalendarViewState({
    required this.startShowingDate,
    required this.endShowingDate,
  });

  void setShowingDateInterval(DateTime startDate, DateTime endDate) {
    startShowingDate = startDate;
    endShowingDate = endDate;
    setState(() {});
  }

  void updateCurrentShowingDates(DateTime startDate, DateTime endDate) {
    setShowingDateInterval(startDate, endDate);
    widget.onDateIntervalChange(startShowingDate, endShowingDate,
        updateView: false);
  }

  void nextShowingPeriod() {
    selectShowingPeriod(1);
  }

  void prevShowingPeriod() {
    selectShowingPeriod(-1);
  }

  void selectShowingPeriod(int index);

  List<Widget> insertEventBox(T event, double eventWidth, double viewDays) {
    var startDate = event.startDate.toLocal();
    var endDate = event.endDate?.toLocal() ?? startDate;
    var startDay = event.startDate.toLocal().day;
    var days = endDate.difference(startDate).inDays + 1;
    List<Widget> eventBoxes = [];
    for (var i = 0; i < days; i++) {
      var eventBoxStartDate = startDate.add(Duration(days: i));
      var startHour = days > 1 && i > 0 ? 0 : eventBoxStartDate.hour;
      var endHour = days > 1 && i + 1 < days
          ? 25
          : (event.endDate?.toLocal().hour ?? startHour);
      var startMin = startDate.minute;
      var endMin = event.endDate?.toLocal().minute ?? (startMin + 30) % 60;
      double topOffset = startHour * 60 + startMin * 1.0 - 10;

      var duration = (endHour + endMin / 60) - (startHour + startMin / 60);
      double height = duration * 60;

      if (event.startDate.weekday + i > 7) continue;

      final left = (event.startDate.weekday + i - 1) * eventWidth;
      final right = (viewDays - event.startDate.weekday - i) * eventWidth;

      eventBoxes.add(CalendarEventBox<T>(
        event: event,
        top: topOffset,
        height: height,
        left: left,
        right: right,
      ));
    }

    return eventBoxes;
  }
}

class CalendarTimestamp<T extends CalendarEvent> extends StatelessWidget {
  final int hour;
  final int min;
  final bool showTime;

  const CalendarTimestamp({
    super.key,
    required this.hour,
    this.min = 0,
    this.showTime = true,
  });

  @override
  Widget build(BuildContext context) {
    var calendarStyle = CalendarStyle.of<T>(context);

    return SizedBox(
        height: 60,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (showTime)
              Container(
                  width: 45,
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(hour.toString(),
                          style: const TextStyle(fontSize: 16)),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                          child: Text(
                            min.toString().padLeft(2, '0'),
                            style: const TextStyle(fontSize: 9),
                          )),
                    ],
                  )),
            Expanded(
                child: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 9),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: calendarStyle.secondaryBackgroundColor, width: 1),
                ),
              ),
            ))
          ],
        ));
  }
}
