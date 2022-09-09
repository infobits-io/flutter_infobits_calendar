import 'package:flutter/material.dart';

import '../calendar_event.dart';
import '../calendar_event_provider.dart';

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
}

class CalendarTimestamp extends StatelessWidget {
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
              decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Color(0xffeeeeee), width: 1)),
              ),
            ))
          ],
        ));
  }
}
